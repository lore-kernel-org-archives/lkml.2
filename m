Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab1LCBqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 20:46:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60031 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab1LCBqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 20:46:11 -0500
X-Authority-Analysis: v=2.0 cv=QqvcLCOd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=dt1uOsUtgTcA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=VwQbUJbxAAAA:8 a=D_SbEOMbAAAA:8 a=20KFwNOVAAAA:8 a=hF0ehI4jzBwU9dV6HKUA:9 a=QEXdDO2ut3YA:10 a=Zh68SRI7RUMA:10 a=7KbvKZvEaC0A:10 a=jEp0ucaQiEUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 00/10] [ANNOUNCE] v3.0.12-rt30-rc1
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
In-Reply-To: <20111203013653.090501690@goodmis.org>
References: <20111203013653.090501690@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Dec 2011 20:46:08 -0500
Message-ID: <1322876768.30977.65.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-02 at 20:36 -0500, Steven Rostedt wrote:
> Dear RT Folks,
> 
> This is the RT stable review cycle of patch 3.0.12-rt30-rc1.
> 
> Please scream at me if I messed something up. Please test the patches too.

I'll be the first to yell at myself. I used my normal tip git pull quilt
script to send out my quilt queue and not the -rt one. (Sorry Andrew,
and Ingo).

The Cc's were suppose to be:

To: 'linux-kernel@vger.kernel.org,linux-rt-users <linux-rt-users@vger.kernel.org>'
Cc: 'Thomas Gleixner <tglx@linutronix.de>,Carsten Emde <C.Emde@osadl.org>,John Kacur <jkacur@redhat.com>'

I'll send again to the correct people.

-- Steve


