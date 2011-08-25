Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab1HYUWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 16:22:32 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:34291 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab1HYUWb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 16:22:31 -0400
Date: Thu, 25 Aug 2011 16:22:16 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH] TTM DMA pool v1
Message-ID: <20110825202216.GA4074@dumpdata.com>
References: <1314206224-15304-1-git-send-email-konrad.wilk@oracle.com>
 <1314286089.6679.3.camel@thor.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1314286089.6679.3.camel@thor.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4E56AF03.0080:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 05:28:09PM +0200, Michel Dänzer wrote:
> On Mit, 2011-08-24 at 13:16 -0400, Konrad Rzeszutek Wilk wrote:
> > 
> > My PowerPC has issues with booting a virgin 3.0 kernel (something about
> > "ELF image not correct") so I don't have that yet covered.
> 
> I tested your patches on my PowerBook with a Radeon.

Thanks! Much appreciated!
> 
> Tested-by: Michel Dänzer <michel@daenzer.net>
> 
> 
> -- 
> Earthling Michel Dänzer           |                   http://www.amd.com
> Libre software enthusiast         |          Debian, X and DRI developer
