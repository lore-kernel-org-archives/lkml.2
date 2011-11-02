Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933228Ab1KBPnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 11:43:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35898 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933171Ab1KBPnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 11:43:32 -0400
X-Authority-Analysis: v=1.1 cv=PzmnriOiyqYdyw8suerSEFMr8oy2Ua58JL+Rk7iuDKE= c=1 sm=0 a=nDqYd8iKHsYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=KKAkSRfTAAAA:8 a=VnNF1IyMAAAA:8 a=9UOrkmwoi0g_yNuSnwAA:9 a=PUjeQqilurYA:10 a=WwgC8nHKvroA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1320248610.4793.35.camel@gandalf.stny.rr.com>
Subject: Re: linux-next 20111025: warnings in
 rcu_idle_exit_common()/rcu_idle_enter_common()
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Carsten Emde <cbe@osadl.org>
Date: Wed, 02 Nov 2011 11:43:30 -0400
In-Reply-To: <20111102151402.GM2287@linux.vnet.ibm.com>
References: <20111031104325.GA25808@localhost>
	 <20111031114142.GA32555@localhost>
	 <20111031121951.GM6160@linux.vnet.ibm.com>
	 <1320075882.4793.4.camel@gandalf.stny.rr.com>
	 <20111101003434.GR6160@linux.vnet.ibm.com>
	 <20111101070720.GA22936@localhost>
	 <20111101160014.GH2287@linux.vnet.ibm.com>
	 <20111101163212.GA19501@localhost>
	 <20111102144403.GA22445@linux.vnet.ibm.com>
	 <1320245512.4793.29.camel@gandalf.stny.rr.com>
	 <20111102151402.GM2287@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-02 at 08:14 -0700, Paul E. McKenney wrote:

> > > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > 
> > I always knew you had a split personality Paul ;)
> 
> Ah, but which is the Good Paul and which is the Evil Paul?  ;-)

Hmm, there's a Paul from Linaro and a Paul from IBM. That shouldn't be
too hard to figure out ;)

-- Steve


