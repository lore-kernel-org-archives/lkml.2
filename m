Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796Ab1CWMxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 08:53:35 -0400
Received: from fep32.mx.upcmail.net ([62.179.121.50]:47369 "EHLO
	fep32.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649Ab1CWMxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 08:53:34 -0400
X-SourceIP: 77.58.148.40
Message-ID: <4D89E99F.30808@odi.ch>
Date: Wed, 23 Mar 2011 13:37:51 +0100
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Thunderbird/3.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: High latency in wine after suspend
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=tMVj8KYobzzX0EiRnC7vY2isLrCxFvdg4RrHWPZXwJ0= c=1 sm=0 a=I24HDECOQz4A:10 a=I-aKXA68520A:10 a=8nJEP1OIZ-IA:10 a=lprJiLIn0XdbWHZakhMA:9 a=GGMa-YBUMs8Y8ltQvWEK2DWNensA:4 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After a suspend/resume cycle I see intermittent high latency in
poll_schedule_timeout (latencytop). This leads to the mouse cursor
freezing for several seconds sometimes when switching to/from a window
of a wine process. The problem never occurs before suspend, but always
occurs after. Any ideas what could cause such behaviour? Kernel is
vanilla 2.6.38 x86_64 running on a recent HP laptop with Intel chipset.

Ortwin

