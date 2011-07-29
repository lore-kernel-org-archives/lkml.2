Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab1G2W6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 18:58:24 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:47061 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab1G2W6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 18:58:23 -0400
Date: Sat, 30 Jul 2011 01:55:59 +0300
From: Dan Carpenter <error27@gmail.com>
To: bojan prtvar <prtvar.b@gmail.com>
Cc: =?iso-8859-1?Q?Jean-Fran=E7ois?= Dagenais 
	<jeff.dagenais@gmail.com>,
        Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
        Andrew Morton <akpm@linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] w1: off by one in w1_f29_remove_slave()
Message-ID: <20110729225559.GI3752@shale.localdomain>
References: <20110727095557.GL3824@shale.localdomain>
 <9C2475AA-829E-4BB8-A3D2-2444803A33D3@gmail.com>
 <CAOmT4fS1OqQb5KOOeFnGHt1tnYGBRutVrAZ4cXB6n=hou5fn8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOmT4fS1OqQb5KOOeFnGHt1tnYGBRutVrAZ4cXB6n=hou5fn8w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 30, 2011 at 12:46:10AM +0200, bojan prtvar wrote:
> 
> Shouldn't it be i>=0 ?
> 

Yup...  Good eye.  Will send a v2 tomorrow.

regards,
dan carpenter

