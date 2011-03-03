Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758999Ab1CCWdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 17:33:50 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:28772 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758868Ab1CCWds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 17:33:48 -0500
Subject: Re: ANNOUNCE: debloat-testing kernel git tree
From: Rick Jones <rick.jones2@hp.com>
Reply-To: rick.jones2@hp.com
To: Tianji Li <Tianji.Li@nuim.ie>
Cc: Dave =?ISO-8859-1?Q?T=E4ht?= <d@taht.net>, sedat.dilek@gmail.com,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        bloat-devel@lists.bufferbloat.net, linux-kernel@vger.kernel.org
In-Reply-To: <4D6FEFD4.9010608@nuim.ie>
References: <20110225222210.GA3618@tuxdriver.com>
	 <AANLkTingkcc-dvs_8Nr0vYXdXvuDHEn6sz14tnHzLp8W@mail.gmail.com>
	 <87fwr9jxya.fsf@cruithne.co.teklibre.org>
	 <AANLkTinpG-xAC-VV-j7EBJB522+BqCyyFd_6N3KEr2Cf@mail.gmail.com>
	 <8739n9ii7z.fsf@cruithne.co.teklibre.org>
	 <AANLkTi=Cp7N4xqPyU6KWF6DOzFytxaA2BeoXhnhsZ6dp@mail.gmail.com>
	 <87tyfph2az.fsf@cruithne.co.teklibre.org> <1299176168.2157.14.camel@tardy>
	 <4D6FEFD4.9010608@nuim.ie>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 14:33:43 -0800
Message-ID: <1299191623.2157.62.camel@tardy>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-03 at 13:45 -0600, Tianji Li wrote:
> 
> On 03/03/2011 12:16 PM, Rick Jones wrote:
> >> For wireless routers and cable home gateways especially, this research
> >> shows that the total un-managed buffers in your system should be less
> >> than 32.
> >
> > Would it be a good thing to start describing these queues not so much in
> > terms of packets but in terms of delay (or bandwidth X delay)?
> >
> 
> The unit of bandwidth is something like Mbps, that of delay can be 
> second, so bandwidth X delay --> Mb, which is the unit of packet size. 
> So both packets and delay should have the same effect for sizing buffers.

Yet, not all packets are not created equal - in size.  So, 42, 150 byte
packets queued is not the same as 42, 1500 byte packets.  However, 10,
1500 byte packets is the same as 100, 150 byte packets.

Had you said something like MB and delay should have the same effect I
would have agreed with you :)

rick jones


