Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab0KOIql (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 03:46:41 -0500
Received: from canuck.infradead.org ([134.117.69.58]:43668 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab0KOIqk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 03:46:40 -0500
Subject: Re: [PATCH v6] Add generic exponentially weighted moving average
 (EWMA) function
From: Peter Zijlstra <peterz@infradead.org>
To: Bruno Randolf <br1@einfach.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, randy.dunlap@oracle.com,
        blp@cs.stanford.edu, linux-kernel@vger.kernel.org,
        Lars_Ericsson@telia.com, kevin.granade@gmail.com,
        "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <201011151650.12406.br1@einfach.org>
References: <4CDC333E.4070104@s5r6.in-berlin.de>
	 <201011151110.46007.br1@einfach.org> <20101115083839.622b58af@stein>
	 <201011151650.12406.br1@einfach.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 15 Nov 2010 09:46:39 +0100
Message-ID: <1289810799.2109.467.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-15 at 16:50 +0900, Bruno Randolf wrote:

> So what would you prefer? And what is the opinion of other people?

ewma_read()
