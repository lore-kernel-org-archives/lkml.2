Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab2JaAdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 20:33:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:53520 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab2JaAdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 20:33:08 -0400
Date: Wed, 31 Oct 2012 01:33:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter LaDow <petela@gocougs.wsu.edu>
cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org, netfilter@vger.kernel.org
Subject: Re: Process Hang in __read_seqcount_begin
In-Reply-To: <CAN8Q1Ef1_OOTpqSrvPB6ja3A3e9-Lky-iceH4NKjWLw8HcW2AA@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1210310130240.2756@ionos>
References: <CAN8Q1EdobyFuAvtajGRSqNsCG+XoPA+FkwN=2j_H126mmfEjTQ@mail.gmail.com> <1350925299.8609.978.camel@edumazet-glaptop> <CAN8Q1EeqmHMHD-VUgr7Wzv0Z_DAD1SrEniftg==L14d+hGwu+Q@mail.gmail.com> <CAN8Q1EcTRsHjCJD90q0bKRJFMvi7Vn8YRsyQTAHNtTFVuuNdWQ@mail.gmail.com>
 <CAN8Q1EeB2kC6A_YP9zdtp_qYHMG5FF7-Usjx7Rz5pv--bjhqkQ@mail.gmail.com> <1351053164.6537.95.camel@edumazet-glaptop> <CAN8Q1Ef9sCAG8-KNWXEeuRUcmFNcg93mMG=HRQw6i3UuGtJCVg@mail.gmail.com> <1351270087.30380.9.camel@edumazet-glaptop>
 <CAN8Q1Ed1J-jmO9LppcA=rFXPvxFkk-J9mMb2-NhDYyAQKO2jvQ@mail.gmail.com> <1351285552.30380.20.camel@edumazet-glaptop> <CAN8Q1Ecx-pDR=NBQm4O=VaynQsxBU1wku9e_kcKkWB=xU0OtMA@mail.gmail.com> <alpine.LFD.2.02.1210262351330.2756@ionos>
 <CAN8Q1Ef1_OOTpqSrvPB6ja3A3e9-Lky-iceH4NKjWLw8HcW2AA@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2012, Peter LaDow wrote:
> Anyway, based on earlier discussion, is there any reason not to use a
> lock (presuming any solution properly takes into account possible
> recursion)?  I understand that the mainline is protected, but perhaps
> in the RT version we can use seqlock (and prevent a recursive lock)?

Have you tried 3.6.3-rt9?
