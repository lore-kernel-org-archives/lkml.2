Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab0JRA0b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 20:26:31 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:34688 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752465Ab0JRA0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 20:26:21 -0400
Subject: Re: [PATCH] IPv4: Remove check for ipv4_is_lbcast() that will
 always return false
From: Andy Walls <awalls@md.metrocast.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, kaber@trash.net
In-Reply-To: <20101012.122841.183039561.davem@davemloft.net>
References: <1286727021.2435.17.camel@localhost>
	 <20101012.122841.183039561.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 17 Oct 2010 20:25:51 -0400
Message-ID: <1287361551.2320.17.camel@morgan.silverblock.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-10-17_08:2010-10-15,2010-10-17,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=5
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1010170109
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-12 at 12:28 -0700, David Miller wrote:
> From: Andy Walls <awalls@md.metrocast.net>
> Date: Sun, 10 Oct 2010 12:10:21 -0400
> 
> > In making an IPv4 routing decision, packets with an all 1's broadcast
> > destination are accepted as input packets, before being checked for being a
> > martian.  Remove the martian check for the all 1's broadcast destination
> > address.  Make the initial check for the all 1's broadcast destination
> > address easier to read.
> > 
> > Signed-off-by: Andy Walls <awalls@md.metrocast.net>
> 
> Your email client corrupted this patch, by turning tab characters
> into spaces, amongst other things.


No, that was me in a rush, thoughtlessly cutting and pasting into the
e-mail client window.

I will resubmit shortly.  Sorry for the wasting your time on the
malformed submission.

Regards,
Andy

> Please give Documentation/email-clients.txt a read and resubmit this
> patch after you have these issues sorted out.
> 
> Thank you.


