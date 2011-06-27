Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab1F0PM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 11:12:56 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:38388 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751264Ab1F0PMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 11:12:48 -0400
Subject: Re: [PATCH] [media] v4l2 core: return -ENOIOCTLCMD if an ioctl 
 doesn't exist
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Sakari Ailus <sakari.ailus@iki.fi>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4E088B83.2050001@redhat.com>
References: <4E0519B7.3000304@redhat.com> <201106262020.20432.arnd@arndb.de>
	 <4E077FB9.7030600@redhat.com> <201106270738.27417.hverkuil@xs4all.nl>
	 <20110627120233.GD12671@valkosipuli.localdomain>
	 <86e5c1f0a0222d3b2cf371f3c9d3b067.squirrel@webmail.xs4all.nl>
	 <4E088B83.2050001@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Jun 2011 11:12:49 -0400
Message-ID: <1309187569.3559.63.camel@morgan.silverblock.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.4.6813,1.0.148,0.0.0000
 definitions=2011-06-27_03:2011-06-25,2011-06-27,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1012030000 definitions=main-1106270064
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-27 at 10:54 -0300, Mauro Carvalho Chehab wrote:

> The right thing to do is to create a separate chapter for error codes, based on errno(3)
> man page [snip]

IMO, the IEEE Std 1003.1 is a better source for errno definitions than
the errno(3) manpage:

http://pubs.opengroup.org/onlinepubs/000095399/functions/xsh_chap02_03.html

Regards,
Andy

