Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769Ab0EYTpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 15:45:42 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55747 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758519Ab0EYTpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 15:45:41 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 25 May 2010 21:45:38 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: post 2.6.34 bug: new code enabled by default
To: linux-media@vger.kernel.org
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.872472794cabd92e@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$ make oldconfig
...
  * Multimedia drivers
  *
  Compile Remote Controller keymap modules (RC_MAP) [M/n/?] (NEW) n
  Enable IR raw decoder for the NEC protocol (IR_NEC_DECODER) [M/n/?] (NEW) n
  Enable IR raw decoder for the RC-5 protocol (IR_RC5_DECODER) [M/n/?] (NEW) n
  Enable IR raw decoder for the RC6 protocol (IR_RC6_DECODER) [M/n/?] (NEW) n
  Enable IR raw decoder for the JVC protocol (IR_JVC_DECODER) [M/n/?] (NEW) n
  Enable IR raw decoder for the Sony protocol (IR_SONY_DECODER) [M/n/?] (NEW) n

Please leave the default of new options at N.

(Unless this were a special case of new options that replaced older
options and need to be migrated to 'on' per default in make oldconfig.
I think this is not the case here.)
-- 
Stefan Richter
-=====-==-=- -=-= ==--=
http://arcgraph.de/sr/


