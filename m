Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab1GESSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 14:18:25 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:43130 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab1GESSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 14:18:24 -0400
X-SENDER-IP: [85.230.173.76]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArpiAIJUE05V5q1MPGdsb2JhbABTiQqefgsBAQEBNzKIegLCPA6GKASXPIMQiCI
X-IronPort-AV: E=Sophos;i="4.65,481,1304287200"; 
   d="scan'208";a="205680928"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 5 Jul 2011 20:20:17 +0200
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: dmitry.torokhov@gmail.com, chase.douglas@canonical.com,
        rubini@cvml.unipv.it, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, derek.foreman@collabora.co.uk,
        daniel.stone@collabora.co.uk, olofj@chromium.org
Subject: Re: [PATCH 07/12] Input: synaptics - rename synaptics_data.mt to agm
Message-ID: <20110705182017.GB29296@polaris.bitmath.org>
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
 <1309324042-22943-8-git-send-email-djkurtz@chromium.org>
 <20110704212640.GD23915@polaris.bitmath.org>
 <CAGS+omCGt_oqkuWPdAtXfuWMvWAD5kL9oxRLmKroRSfLAk8VGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGS+omCGt_oqkuWPdAtXfuWMvWAD5kL9oxRLmKroRSfLAk8VGg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > How about just modifying the comment, i.e., leaving this hunk?
> 
> IMHO, changing the field name from mt to agm makes the following
> patches more clear, by making it easier to see the difference between
> sgm and agm packets.

If there was a field called sgm, I would agree with you. ;-)

Thanks,
Henrik
