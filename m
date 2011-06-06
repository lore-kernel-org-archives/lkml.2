Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040Ab1FFVns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 17:43:48 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59781 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab1FFVnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 17:43:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=WlKhdBfzlifHlO1EY9pdfkUCeFm6hUwub8DHJnGMfpJIh9aQPO+xrjWdtF+2n2Ppoy
         HmY8cHJkrTVR8TegRoyXKHqDYJSKOpvFDIxxrn4WJE8pBMKrY/7gQe/06IG0GI1TEzDd
         a+5APfRGthxIW1QH2E7O4p7nTxGYKxJHHlsN8=
MIME-Version: 1.0
In-Reply-To: <BANLkTinHYQ14A7vzTxA1c2frxUVE6HWNQg@mail.gmail.com>
References: <1307389135-8150-1-git-send-email-mjg@redhat.com>
	<1307389135-8150-2-git-send-email-mjg@redhat.com>
	<BANLkTinHYQ14A7vzTxA1c2frxUVE6HWNQg@mail.gmail.com>
Date: Mon, 6 Jun 2011 14:43:46 -0700
X-Google-Sender-Auth: IIF8v1dmTGtTlZfjBsPPcFDLg60
Message-ID: <BANLkTimESgP1FMzP8cbKcECLSbEY9Mj3bQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] pstore: Add extra context for writes and erases
From: Tony Luck <tony.luck@intel.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Matt_Domsch@dell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 12:38 PM, Matthew Garrett <mjg@redhat.com> wrote:
-       if (owner && !try_module_get(owner)) {
-               psinfo = NULL;
-               return -EINVAL;
-       }
-

Apart from the accidental deletion of this chunk (as discussed on
IRC), it all looks
good to me.  The ERST stuff still works, I didn't try the new EFI bits.  So you
can have:

Acked-by: Tony Luck <tony.luck@intel.com>

to add to these ... unless I'm the one pushing them to Linus, in which case I'll
add my Signed-off-by for parts 1 & 2

Does someone claim maintainership of  drivers/firmware/efivars.c for part3?

-Tony
