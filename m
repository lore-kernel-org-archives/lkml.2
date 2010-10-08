Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab0JHMwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 08:52:35 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:55700 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753429Ab0JHMwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 08:52:34 -0400
Message-Id: <1286542354.10969.1399038639@webmail.messagingengine.com>
X-Sasl-Enc: DbR18pfLHdHWP5y13Nlw9EpSnTbhtxnYk8mniRCBFluA 1286542354
From: "Jack Stone" <jwjstone@fastmail.fm>
To: "Nicolas Kaiser" <nikai@nikai.net>,
        "Dan Williams" <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
In-Reply-To: <1286540528.5117.1399034495@webmail.messagingengine.com>
References: <20101008004801.2f0dee47@absol.kitzblitz>
 <1286540528.5117.1399034495@webmail.messagingengine.com>
Subject: Re: [PATCH] dma/timberdale: simplify conditional
Date: Fri, 08 Oct 2010 13:52:34 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's just not my day today.

I had a look on LXR and rx is defined as a bool so we're safe in this
case but might be worth a comment or even !! to future proof it.

Sorry for all the noise, Jack
