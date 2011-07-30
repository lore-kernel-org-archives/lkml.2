Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392Ab1G3Ixm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 04:53:42 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:41103 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab1G3Ixf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 04:53:35 -0400
Date: Sat, 30 Jul 2011 11:51:31 +0300
From: Dan Carpenter <error27@gmail.com>
To: walter harms <wharms@bfs.de>
Cc: =?iso-8859-1?Q?Jean-Fran=E7ois?= Dagenais 
	<jeff.dagenais@gmail.com>,
        Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
        Andrew Morton <akpm@linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] w1: off by one in w1_f29_remove_slave()
Message-ID: <20110730085131.GE5575@shale.localdomain>
References: <20110727095557.GL3824@shale.localdomain>
 <9C2475AA-829E-4BB8-A3D2-2444803A33D3@gmail.com>
 <4E33C3F5.9000602@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E33C3F5.9000602@bfs.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 30, 2011 at 10:42:29AM +0200, walter harms wrote:
> Is there any reason to release the data "backwards" ?
> The default way is to go upwards. that looks more readable.

I considered doing it that way.  It would work.  I throught maybe
they were going to add something where it needed to be unwound LIFO
order.

I'll wait for Jean-Françoisto say which way is prefered.

regards,
dan carpenter
