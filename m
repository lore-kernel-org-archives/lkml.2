Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab1GFObu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 10:31:50 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:39372 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753148Ab1GFObt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 10:31:49 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 2vjRO1sVM1nTBh3.kDTkTTchiF58KyJyx_MC6n86a5dZvWG
 dmlvpIzYnciQFb92b1Sy2YlQYp.FQDfReGDptwQzb8Z2m8z0kV2HsQyNQDbg
 JGV0vGLPfjM3ohYH.FpWeLfj5D5y42why9dQS.Z9JqNyh6G9UVhEJV21Werl
 _5x04c8ywBnelGPNcjesu8mOIZGoOpV71huOxTxDxunEjkg5NWzvqI9tVpLg
 ybNkepxTf0Cg_BIEoVvESKtugY9AIxOEnH35.6fwONk9K5FmZfM4ow_26z5V
 WvBggFjJkFYWCQ60uhhDkvxlMTzeHwAHT8F4sp66aD_r5tD.N6AUo3i3RFhI
 f6z_JI7qQNDKixZnb_3rXmojf
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 6 Jul 2011 09:31:45 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Peter Kruse <pk@q-leap.de>
cc: Dave Chinner <david@fromorbit.com>, Mel Gorman <mel@csn.ul.ie>,
        David Rientjes <rientjes@google.com>, eric.dumazet@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: I have a blaze of 353 page allocation failures, all alike
In-Reply-To: <4E1405C3.20904@q-leap.de>
Message-ID: <alpine.DEB.2.00.1107060931190.17202@router.home>
References: <272bf0cc51439a2ab31ee2f06317dd9f.squirrel@www.q-leap.de> <4D6648B5.1090306@q-leap.com> <4DA4692D.7080207@q-leap.de> <alpine.DEB.2.00.1104121306581.14692@router.home> <alpine.DEB.2.00.1104121830030.14956@chino.kir.corp.google.com>
 <4DA54D2A.3050206@q-leap.de> <alpine.DEB.2.00.1104131116330.19493@router.home> <4E09BEA1.1080501@q-leap.de> <alpine.DEB.2.00.1107051013500.16869@router.home> <20110705172043.GA15147@csn.ul.ie> <20110706041602.GX1026@dastard> <4E1405C3.20904@q-leap.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jul 2011, Peter Kruse wrote:

> Ok then I think we will schedule a kernel update and if the
> server then runs for more than 40 days we could say that
> the problem is fixed.

Note that this is *not* the original problem you reported. I do not see
page alloc failures in your latest logs.

