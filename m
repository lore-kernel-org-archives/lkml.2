Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab0FBMwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 08:52:04 -0400
Received: from smtpauth.net4india.com ([202.71.129.41]:37289 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab0FBMwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 08:52:01 -0400
Message-ID: <4C065423.3000202@xenontk.org>
Date: Wed, 02 Jun 2010 18:22:51 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Mozilla/5.0 (X11; X; Linux x86_64; rv:1.9.1.9) Gecko/20100430 Thunderbird/3.0.4
MIME-Version: 1.0
To: cworth@cworth.org
CC: Dave Airlie <airlied@linux.ie>, Eric Anholt <eric@anholt.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [2.6.35-rc1 Regression] i915: Commit cfecde causes VGA to stay off
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Commit cfecde 'drm/i915: Don't enable pipe/plane/VCO early (wait for
DPMS on)' causes the external VGA connector to stay off on boot. The
display powers up when X is started. I'm guessing an explicit DPMS ON
is not done on boot.

Reverting this commit fixes the issue.

Regards,
David.
