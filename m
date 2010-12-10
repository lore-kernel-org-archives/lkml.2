Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab0LJTko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 14:40:44 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:28430 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755486Ab0LJTkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 14:40:43 -0500
Subject: Re: [stable] [RESEND][PATCH for stable 2.6.36 REGRESSION] cx25840:
 Prevent device probe failure due to volume control ERANGE error]
From: Andy Walls <awalls@md.metrocast.net>
To: Greg KH <greg@kroah.com>, mchehab@redhat.com
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, hverkuil@xs4all.nl, gregkh@suse.de
In-Reply-To: <20101210181630.GA12772@kroah.com>
References: <1291987197.2064.8.camel@morgan.silverblock.net>
	 <20101210181630.GA12772@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Dec 2010 14:41:03 -0500
Message-ID: <1292010063.29254.13.camel@morgan.silverblock.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-12-10_10:2010-12-10,2010-12-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1010190000 definitions=main-1012100097
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-10 at 10:16 -0800, Greg KH wrote:
> On Fri, Dec 10, 2010 at 08:19:57AM -0500, Andy Walls wrote:
> > Resending, since this didn't appear to make its way into in 2.6.36.2.
> 
> That's because it's not in Linus's tree, right?  I have to wait for that
> to happen before I can add it to a stable tree.

Greg,

I wasn't aware of that constraint in the process, but it makes sense to
me.


Mauro,

My understanding is that the patch has to be in one of your trees first,
and then tested in linux-next for a reasonable length of time, before
Linus will pull it into his tree.

Could you please expedite handling of this patch for 2.6.37:

	https://patchwork.kernel.org/patch/376612/

so that the regression can be fixed in 2.6.36?

Regards,
Andy

