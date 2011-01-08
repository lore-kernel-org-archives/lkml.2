Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab1AHAUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 19:20:05 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47010 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab1AHAUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 19:20:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GUd+U750kEWEG/vSG1bbsQC49fiA4bnDCcx3WOC7dG6LaPH55JGpWuXHb1cPZg6P94
         knoUhZOTKxwc7jpY9l+Ud7BwV+u+g214V1AkCksH5WVlp4FuTJdq31IbjP2mSYByflSI
         n06d9tiFl6G0NMTkTOlnllBMtddfqolEycTeo=
MIME-Version: 1.0
In-Reply-To: <20110107223333.GA1006@srcf.ucam.org>
References: <1292901555-16213-1-git-send-email-airlied@gmail.com>
	<20110107223333.GA1006@srcf.ucam.org>
Date: Sat, 8 Jan 2011 10:20:02 +1000
Message-ID: <AANLkTimY8rv9V52M9iZNF2AsX4Eg3fexfwCt3cNBEWbE@mail.gmail.com>
Subject: Re: [RFC PATCH] platform/x86: add MXM WMI driver.
From: Dave Airlie <airlied@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 8, 2011 at 8:33 AM, Matthew Garrett <mjg@redhat.com> wrote:
> Are you looking for this to be merged at the moment? If so, the printks
> probably ought to be conditional on a debug parameter (is the drm debug
> level exported?).

I was looking for some feedback on whether it was sane first ;0

But since it relies on nouveau changes to make it do anything and its
all under debugfs I was going to leave the printks alone until we could get
some debugging on more hw than my one laptop.

Dave.
