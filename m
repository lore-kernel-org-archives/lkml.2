Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab2DPGUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 02:20:05 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2836 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab2DPGUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 02:20:03 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6681"; a="181945224"
X-IronPort-AV: E=Sophos;i="4.75,426,1330934400"; 
   d="scan'208";a="302904103"
Message-ID: <4F8BBA0E.9080506@qca.qualcomm.com>
Date: Mon, 16 Apr 2012 09:19:58 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Tim Gardner <tim.gardner@canonical.com>
CC: <linux-kernel@vger.kernel.org>, ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH linux-next 0/1] ath6k: Normalize use of FW_DIR
References: <1334337448-26270-1-git-send-email-tim.gardner@canonical.com>
In-Reply-To: <1334337448-26270-1-git-send-email-tim.gardner@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

On 04/13/2012 08:17 PM, Tim Gardner wrote:
> Kalle - I've been cleaning out old firmware files in the Ubuntu linux-firmware
> package and noticed that there are a number of AR6004 firmware files referenced in
> the ath6k USB driver that do not exist in the upstream linux-firmware
> repository. Are y'all planning to submit them soon ?

I submitted ar6004 hw1.2 firmware files last week and Ben applied them
yesterday. ar6004 hw1.0 and hw1.1 again are more like internal releases
so we are planning to send any firmware files for them.

Kalle
