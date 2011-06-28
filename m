Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252Ab1F1OAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 10:00:38 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:38573 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757398Ab1F1N6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 09:58:49 -0400
Message-ID: <4E09DE03.3090100@st.com>
Date: Tue, 28 Jun 2011 19:28:27 +0530
From: deepaksi <deepak.sikri@st.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.5) Gecko/20091204 Lightning/1.0b1 Thunderbird/3.0
MIME-Version: 1.0
To: <linux-pm@lists.linux-foundation.org>, <deepak.sikri79@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Suspend to RAm query
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I have a very basic query w.r.t the place to handle the standby/suspend
process for the devices in the system.

Should it be done at the driver level or in the machine/platform
specific code ?

There are instances where I need some specific functionality in the
standby mode, or some extra functionality
in the suspend mode at the device level. Is that the reason for
differentiating between the suspend and standby at
the platform code level, because in platform code we get different
states signifying a suspend or a standby ?

Thanks
Deepak
