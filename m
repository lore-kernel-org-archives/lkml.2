Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab1ERJDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 05:03:07 -0400
Received: from latitanza.investici.org ([82.94.249.234]:35560 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab1ERJDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 05:03:05 -0400
X-Greylist: delayed 1053 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 May 2011 05:03:05 EDT
X-DKIM: Sendmail DKIM Filter v2.8.2 latitanza.investici.org 785A0981DB
Date: Wed, 18 May 2011 10:45:35 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: linux-kernel@vger.kernel.org
Subject: Suggestion for patch: Comparison between packet sequence numbers
Message-ID: <20110518084535.GA24682@ritirata.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I would like to send a patch that introduces a little set of global defines
that manages comparison between packet sequence numbers (considering
overflow/wraparound). But honestly, I didn't find the right header where to
add these defines.

Could someone suggest me something?

Regards,

-- 
Antonio Quartulli

..each of us alone is worth nothing..
Ernesto "Che" Guevara
