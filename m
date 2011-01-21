Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab1AUTjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 14:39:44 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22834 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab1AUTjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 14:39:43 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6233"; a="71204709"
Subject: Attribute Server and Client TODOs
From: Brian Gix <bgix@codeaurora.org>
To: claudio.takahasi@openbossa.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: Code Aurora Forum
Date: Fri, 21 Jan 2011 11:39:43 -0800
Message-ID: <1295638783.1774.21.camel@ubuntuLab1>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Claudio, etc,

We are starting to look at the adopted LE profiles, and it is becoming
clear that Higher layer (Applications etc) server support will be needed
for some of the significant use cases such as Proximity.  Is anybody
currently working on a D-Bus interface to the Attribute Server?  I know
there is nothing in code that has been up-streamed yet, but I was
wondering if anyone has put some thought into what a D-Bus interface for
the Attribute Server might look like?

Also, one of my compatriots is telling me that she cannot get the GATT
Client D-Bus interface to work.  I don't know if this is a simple lack
of Introspection Data (required by d-feet), or if there is a build or
configuration parameter that needs to be setup.  I have just been using
the gatttool to run my tests, and not going through D-Bus.  If anybody
has been using D-Bus for GATT Client testing, I would be interested in
finding out if there is some setup requirements that I am missing.


Thanks for your time.

-- 
Brian Gix
bgix@codeaurora.org
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum

