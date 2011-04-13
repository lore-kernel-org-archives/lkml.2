Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004Ab1DMQRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:17:36 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:39062 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932360Ab1DMQRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:17:34 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: XllK3b0VM1l027GvwAPK1UhQrTrlrGI38w_x0Ue62dvKq_A
 0DwqAUeIY2XpTpVdkPXJR.Pon6BhaFD7rE1o2zcnOgEgjRj7KcZKiNuGkBeP
 53a77h4Pxia4kdYL1rIVQihr2PpxEEEcbywt48n_8c2upzTP8g5qQZqRBWRp
 WK5n87.UivPK_9_sPycEdIcVmq_5g4O1W7b4K8XQipsWd90RqEX8O9uUyCLg
 l2bDsW1OOzJ6hjFr_sBZrqj.CZFruJqLMxvia59Y_pgIHZrAamd.CUzjB_7x
 EAUQb74caF_eBImTrkYP_XNX5hxgZhmlBaJoo8FjRiEuihYonVGoekfgJZHh
 Rk6VV4jFVOtig2iSVtG2agq5O
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 13 Apr 2011 11:17:31 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Peter Kruse <pk@q-leap.de>
cc: David Rientjes <rientjes@google.com>, eric.dumazet@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: I have a blaze of 353 page allocation failures, all alike
In-Reply-To: <4DA54D2A.3050206@q-leap.de>
Message-ID: <alpine.DEB.2.00.1104131116330.19493@router.home>
References: <4D53FE43.8030106@q-leap.com>    <alpine.DEB.2.00.1102141046170.26158@router.home>    <4D5A2EDB.8060603@q-leap.com>    <alpine.DEB.2.00.1102151040560.10511@router.home>    <4D5BC16A.2090205@q-leap.com>    <alpine.DEB.2.00.1102160956250.27814@router.home>
 <4D5BF56F.1000504@q-leap.com>    <alpine.DEB.2.00.1102161010330.27814@router.home>    <4D5CCEED.3010501@q-leap.com>    <alpine.DEB.2.00.1102171102520.11140@router.home> <272bf0cc51439a2ab31ee2f06317dd9f.squirrel@www.q-leap.de> <4D6648B5.1090306@q-leap.com>
 <4DA4692D.7080207@q-leap.de> <alpine.DEB.2.00.1104121306581.14692@router.home> <alpine.DEB.2.00.1104121830030.14956@chino.kir.corp.google.com> <4DA54D2A.3050206@q-leap.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Apr 2011, Peter Kruse wrote:

> Hello,
>
> thanks for your replies, I appreciate that.
>
> On 04/13/2011 03:34 AM, David Rientjes wrote:
> > On Tue, 12 Apr 2011, Christoph Lameter wrote:
> >
> > > The problem maybe that you have lots and lots of SCSI devices which
> > > consume ZONE_DMA memory for their control structures. I guess that is
> > > oversubscribing the 16M zone.
>
> but there are only two devices:

The output you sent me showed a long list of devices. Maybe there is a
broken driver /device that continues being probed?
