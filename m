Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab1FNS2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 14:28:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56090 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab1FNS2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 14:28:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=SgfZSJRgCH5SjG6eSVHPedbVMByabxPzEBBlTtiDlxzBuf9DEpBL5whbevQG2hOJVR
         WrLW9cvjDfx0v5A4jJjsC6UmI0Tnf77jKM2rDc3Bir05qclG+2zU1ri1a1eYX+sai+jb
         XNKkBZPVzBzr36Vc4KPENE68PLU7avKidVpyQ=
MIME-Version: 1.0
In-Reply-To: <BANLkTina_Y5xekoE9SnbG125CVFLopym2A@mail.gmail.com>
References: <4df13a522720782e51@agluck-desktop.sc.intel.com>
	<4df13cea27302b7ccf@agluck-desktop.sc.intel.com>
	<20110612223840.GA23218@aftab>
	<BANLkTi=-A5PYj8zpjGB4Xb-_VNq0qr+CGQ@mail.gmail.com>
	<4DF5C36A.1040707@redhat.com>
	<20110613095521.GA26316@aftab>
	<4DF5F729.4060609@redhat.com>
	<20110613124003.GA27918@aftab>
	<4DF606C9.90308@redhat.com>
	<20110613151208.GA29045@aftab>
	<4DF63B7A.1030805@redhat.com>
	<BANLkTinUEqRni2u0DaMfSc45b3DmMMyYvA@mail.gmail.com>
	<4DF6CC58.8050601@jp.fujitsu.com>
	<4DF6CD25.7040405@jp.fujitsu.com>
	<BANLkTina_Y5xekoE9SnbG125CVFLopym2A@mail.gmail.com>
Date: Tue, 14 Jun 2011 11:28:42 -0700
X-Google-Sender-Auth: 1NsSpn5kDSXv5ERU7pONHNyNya0
Message-ID: <BANLkTimY1X73pTJmMd8G5GKpsCBVmXLfOw@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86, mce: rework use of TIF_MCE_NOTIFY
From: Tony Luck <tony.luck@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Borislav Petkov <bp@amd64.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 11:02 AM, Tony Luck <tony.luck@intel.com> wrote:
> need (failing address) to take some action. That was put into
> the ring

Correction - we only put the pfn into the ring for AO (action optional)
errors [in the current state of the patch series].

But the need for a path to get the pfn from the MC handler to the
mce_notify_process() function remains the same.

-Tony
