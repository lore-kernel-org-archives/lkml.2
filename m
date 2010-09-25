Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054Ab0IYWzv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 18:55:51 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:43742 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752125Ab0IYWzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 18:55:50 -0400
X-Greylist: delayed 589 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Sep 2010 18:55:50 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj4DABkYnkxFpamy/2dsb2JhbAAHoT3GS4VDBJF5
X-IronPort-AV: E=Sophos;i="4.57,237,1283745600"; 
   d="scan'208";a="76913623"
Message-ID: <4C9E7BA6.6070602@polymtl.ca>
Date: Sat, 25 Sep 2010 18:45:58 -0400
From: Alexandre Montplaisir <alexandre.montplaisir@polymtl.ca>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100922 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, ubuntu-devel-discuss@lists.ubuntu.com,
        ltt-dev <ltt-dev@lists.casi.polymtl.ca>
Subject: [ANNOUNCE] LTTng kernel packages for Ubuntu Maverick
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


LTTng, the Linux Trace Toolkit Next Generation, is a project that aims 
at producing a highly efficient full system tracing solution.  It is 
composed of several components to allow tracing of the kernel, of 
userspace, trace viewing and analysis and trace streaming.  LTTng is 
open source software. It is being actively developed with the community.


Hi all,

A LTTng-patched kernel package for Ubuntu Maverick has been uploaded to 
a PPA[1], which should greatly simplify the installation procedure.

The PPA also contains packages for other related projects, namely LTTv 
(the trace visualizer) and UST (the Userspace Tracer). They will be kept 
up-to-date to follow the upstream releases as much as possible.

[1] https://launchpad.net/~lttng/+archive/ppa


Project website: http://lttng.org


Thanks,

--
Alexandre Montplaisir
DORSAL lab,
École Polytechnique de Montréal
