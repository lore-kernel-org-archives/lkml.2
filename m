Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab0HaJGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 05:06:06 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46834 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649Ab0HaJGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 05:06:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qfiInnysC6AK8an12eI8ZqRhILfftgtFazEiVz4UlfQpce49PdO8gwwdV/4hhUzIpN
         5uocXCimpJj/xWF2ZxfdQeskqi2+sEONRzl1SIgiZoAQDgQaJrDkBoUjGDc2d9Hydlwm
         G6Im2chi3m5i6HHcINbOgIk/5x3Z2BH2pIgoU=
MIME-Version: 1.0
In-Reply-To: <1281990739-17912-1-git-send-email-mjg@redhat.com>
References: <1281990739-17912-1-git-send-email-mjg@redhat.com>
Date: Tue, 31 Aug 2010 10:06:02 +0100
Message-ID: <AANLkTik620+_nBE+24-ausDet_uhRZD9JmfEV20vy8TU@mail.gmail.com>
Subject: Re: [PATCH] acpi: Update battery information on notification 0x81
From: Richard Hughes <hughsient@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 August 2010 21:32, Matthew Garrett <mjg@redhat.com> wrote:
> A notification event 0x81 from an ACPI battery device requires us to
> re-read the battery information structure. Do so, and if the battery's
> reporting units have changed (as is the case on some Thinkpads) destroy
> and recreate the battery in order to populate the fields correctly.

I've had three reports in upower of this bug (the units changing) so
users are really hitting this in real world usage. As soon as this
kernel fix gets released in a new kernel version I'll remove the
upower workaround. I can't reproduce this myself, so I've not tested
the patch, although the logic is solid in my opinion.

Richard.
