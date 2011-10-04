Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269Ab1JDOiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 10:38:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:54034 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932210Ab1JDOiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 10:38:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,485,1312182000"; 
   d="scan'208";a="70168263"
Date: Tue, 4 Oct 2011 17:38:04 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>
Cc: Fabio Estevam <festevam@gmail.com>, Sascha Hauer <s.hauer@pengutronix.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Chen <peter.chen@freescale.com>,
        Lin Tony-B19295 <B19295@freescale.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>
Subject: Re: [PATCHv5 14/19] arm: imx: Start using struct usb_otg
Message-ID: <20111004143804.GA2558@xps8300>
References: <1317036092-3000-1-git-send-email-heikki.krogerus@linux.intel.com>
 <20111003130409.GA2487@xps8300>
 <CAOMZO5DwDiBa_Ksow5bt02S_zMMEn4uB_hz-5KS+dyNiZA88sQ@mail.gmail.com>
 <201110041551.20254.philippe.retornaz@epfl.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201110041551.20254.philippe.retornaz@epfl.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 03:51:19PM +0200, Philippe Rétornaz wrote:
> > Adding Philippe who has access to the mx31moboard-devboard and maybe
> > could run a test?
> 
> On which tree should I test thoses patches ? 3.0 does not apply.

Linus's tree. It's possible that our smtp server has done something it
should not have. If this is the case, you will find this patch set here:

git://github.com/krohei/linux.git branch otg

-- 
heikki
