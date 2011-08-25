Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab1HYWmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 18:42:21 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:56997 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729Ab1HYWmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 18:42:20 -0400
MIME-Version: 1.0
In-Reply-To: <1314282450.1606.43.camel@vkoul-udesk3>
References: <Pine.LNX.4.64.1108181648370.5245@axis700.grange>
	<1314282450.1606.43.camel@vkoul-udesk3>
Date: Thu, 25 Aug 2011 15:42:20 -0700
X-Google-Sender-Auth: 083IOfH_WYZ_8bW9TqfizXVVi0M
Message-ID: <CAA9_cmf=t_n7bKT=eS7oFSyBd2wJGiabVpcVjp2d3jN_wKRnyg@mail.gmail.com>
Subject: Re: [PATCH] dmatest: make dmatest threads freezable
From: Dan Williams <dan.j.williams@intel.com>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 7:27 AM, Koul, Vinod <vinod.koul@intel.com> wrote:
> On Thu, 2011-08-18 at 16:50 +0200, Guennadi Liakhovetski wrote:
>> Making dmatest threads freezable allows its use for system PM testing.
>>
>> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Looks good to me, Dan if you give me your ack, I will carry this in my
> tree

Acked-by: Dan Williams <dan.j.williams@intel.com>
