Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab1BIDpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 22:45:31 -0500
Received: from bosmailout05.eigbox.net ([66.96.190.5]:34445 "EHLO
	bosmailout05.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223Ab1BIDpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 22:45:30 -0500
X-Greylist: delayed 2619 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Feb 2011 22:45:30 EST
X-EN-OrigOutIP: 10.20.18.10
X-EN-IMPSID: 5f1n1g0080D2CUy01f1nAA
Message-ID: <4D520535.6080408@jaysonking.com>
Date: Tue, 08 Feb 2011 21:08:37 -0600
From: "Jayson R. King" <dev@jaysonking.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Stable team <stable@kernel.org>
Subject: 2.6.27.58-rc1 build error Re: [PATCH 20/23] tracing: Fix panic when
 lseek() called on "trace" opened for writing
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 06af1bc540adb20c3d2d7097199478a6:08dd1976e651f6e3791fbe97eaa5f898
X-EN-AuthUser: jaysonking@jaysonking.com
X-EN-OrigIP: 67.65.251.18
X-EN-OrigHost: adsl-67-65-251-18.dsl.okcyok.swbell.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like a typo was made in this patch for 2.6.27.58-rc1:

	kernel/trace/trace.c:2055: error: 'tracing_lseek' undeclared here (not 
in a function)



'tracing_lseek' likely should be 'tracing_seek' in the two occurances in 
this patch.

Jayson

