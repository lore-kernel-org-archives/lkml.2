Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab0KKWtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 17:49:13 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64823 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab0KKWtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 17:49:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MncUCm+HO4cvcr7ub/nnJT3xJ3iIcy5f0UWPxrnaPn02AtbyJR0hjRe+vXH80FG5/U
         o+LKfQbFpkFveSXFi4NYh6xmYHRI8zCpeIueuVCoL7rrlkE1kfDU+Exbb3F6hLJycNpi
         YC6JS4CK55PY2qgJOQBB6hQnUOw4Jw95UndOc=
Subject: Re: 2.6.3x-rty where x > 3 and y >= 1?
From: Ng Oon-Ee <ngoonee@gmail.com>
To: =?ISO-8859-1?Q?Niccol=F2?= Belli <darkbasic4@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
        linux-kernel@vger.kernel.org,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        johnstul@us.ibm.com, rostedt@goodmis.org, npiggin@suse.de
In-Reply-To: <4CDC0429.8090506@gmail.com>
References: <4CDAF425.4050800@ccrma.stanford.edu>
	 <alpine.LFD.2.00.1011102154330.2900@localhost6.localdomain6>
	 <4CDC0429.8090506@gmail.com>
Content-Type: text/plain; charset="ISO-8859-9"
Date: Fri, 12 Nov 2010 06:49:02 +0800
Message-ID: <1289515742.14141.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 15:56 +0100, Niccolò Belli wrote:
> Il 10/11/2010 21:54, Thomas Gleixner ha scritto:
> > Working on it :)
> 
> Glad to hear that, I can't use 2.6.33-rt anymore because of problems
> with my intel video card and my band is starting to blame because of xruns.
> 
> Darkbasic

In the meantime, the -bfs kernel does improve the situation somewhat.

