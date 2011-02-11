Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901Ab1BKSBD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 13:01:03 -0500
Received: from smtp-out.google.com ([216.239.44.51]:34420 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757753Ab1BKSBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 13:01:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Z0QqLZLd+cYgz/Mv6OQAbKSnqyJfyP05e4LXijr+02RyE5OO3W0cYmUla4CAcBGbe6
         y5Q9qk7fVQiJ8JoBsAaQ==
MIME-Version: 1.0
In-Reply-To: <AANLkTin3tu-NiotpzWaQ_ubV0jumb_WsjEK5QGi5w56o@mail.gmail.com>
References: <4D547236.6080702@google.com> <20110211012552.GA28995@kroah.com>
 <AANLkTi=tbYj_bonu2i+NHpNY3KUMpsTVT8YDsLhDz_Nm@mail.gmail.com>
 <20110211032049.GB884@kroah.com> <AANLkTin3tu-NiotpzWaQ_ubV0jumb_WsjEK5QGi5w56o@mail.gmail.com>
From: Mike Waychison <mikew@google.com>
Date: Fri, 11 Feb 2011 10:00:37 -0800
Message-ID: <AANLkTi=Umq5gPr4xT4iChm+B+C+TOF1SB8gC4_ygqztR@mail.gmail.com>
Subject: Re: SMBIOS / DMI Event Logs in Linux?
To: Greg KH <greg@kroah.com>
Cc: Tim Hockin <thockin@google.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Robert Lippert <rlippert@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

resend as plain text, sorry :(


On Thu, Feb 10, 2011 at 7:20 PM, Greg KH <greg@kroah.com> wrote:
> Wait, if this is just a simple "pass through to the hardware", then just
> export the thing, with the proper permissions, in a single binary sysfs
> file, and do the parsing in userspace.
>

If you mean s/hardware/firmware/, then yes.

>
> That would be the simplest thing to do, and fit the rules for valid
> sysfs files, and keep people from having to dig through /dev/mem, right?

Yup, exposing the log via a bin_attribute and allowing for blobs to be
appended (with the firmware either accepting or rejecting the format
will do).
