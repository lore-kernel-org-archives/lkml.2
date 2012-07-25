Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094Ab2GYNuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 09:50:44 -0400
Received: from mail.nonattached.net ([193.160.39.60]:38965 "EHLO
	mail.nonattached.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933018Ab2GYNun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 09:50:43 -0400
Subject: FYI: Example [Re: [PATCH] scripts/kernel-doc: added support for
 html5]
From: Dan Luedtke <mail@danrl.de>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1343223488-1332-1-git-send-email-mail@danrl.de>
References: <1343223488-1332-1-git-send-email-mail@danrl.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Jul 2012 15:50:36 +0200
Message-ID: <1343224236.4893.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-25 at 15:38 +0200, Dan Luedtke wrote:
> New output option html5 writes validating HTML5 and adds
> CSS classes ready to be selected by third-party stylesheets.

An example, generated with the patched version of kernel-doc:

https://www.nonattached.net/lanyfs/doc-linux.php

Uses CSS like this:

article.doc,
article.enum,
article.typedef,
article.struct,
article.function {
	margin-bottom: 50px;
}
/* markup */
span.keyword {
	font-weight: bold;
	color: #000;
}
span.type {
	font-weight: normal;
	color: #284689;
}
span.identifier {
	font-weight: bold;
	color: #c43;
}

-- 
Dan Luedtke
http://www.danrl.de

