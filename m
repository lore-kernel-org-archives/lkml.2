Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab2D3Wdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 18:33:53 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57095 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756939Ab2D3Wdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 18:33:51 -0400
MIME-Version: 1.0
In-Reply-To: <1335816690-26019-1-git-send-email-mjg@redhat.com>
References: <1335816690-26019-1-git-send-email-mjg@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 30 Apr 2012 15:33:30 -0700
X-Google-Sender-Auth: mpqbbnlDoStfiwuM3GSzkcjJKGY
Message-ID: <CA+55aFzG_CQ29eNs=7uWv2Gr_AVDSiVKfPn2DjOoeG9yfN+AtA@mail.gmail.com>
Subject: Re: [PATCH 1/2] efi: Add new variable attributes
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, both patches applied,

                Linus

On Mon, Apr 30, 2012 at 1:11 PM, Matthew Garrett <mjg@redhat.com> wrote:
> More recent versions of the UEFI spec have added new attributes for
> variables. Add them.
