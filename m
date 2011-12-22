Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab1LVLub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 06:50:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62047 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab1LVLuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 06:50:21 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=bSSgsQw5cEFz1OcLzhcA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [ANNOUNCE] 3.0.14-rt31
From: Steven Rostedt <rostedt@goodmis.org>
To: Raz <raziebe@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
In-Reply-To: <CAPB=Z-rrMLyFAJXUBC+BCqegr2bNB4on0gNaTWY-ddMWsMGJpA@mail.gmail.com>
References: <1324525237.5916.114.camel@gandalf.stny.rr.com>
	 <CAPB=Z-rrMLyFAJXUBC+BCqegr2bNB4on0gNaTWY-ddMWsMGJpA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Dec 2011 06:50:20 -0500
Message-ID: <1324554620.8892.1.camel@acer.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-22 at 13:08 +0200, Raz wrote:
> Hey steven
> 
> what is the relation between 3.2 rt patches and 3.0 rt patches ? back
> portability or anything else ?

3.0-rt is the stable release. 3.2-rt is active development. Only fixes
go into 3.0-rt.

-- Steve


