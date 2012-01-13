Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521Ab2AMJir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 04:38:47 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45850 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab2AMJiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 04:38:46 -0500
MIME-Version: 1.0
In-Reply-To: <4F0FFA58.7010702@cn.fujitsu.com>
References: <1322704427-11876-1-git-send-email-Barry.Song@csr.com> <4F0FFA58.7010702@cn.fujitsu.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 13 Jan 2012 17:38:24 +0800
Message-ID: <CAGsJ_4zhe1C4hVzmpcQYS5LDzxM==M6acQEH2eXM5aCvnf+XNQ@mail.gmail.com>
Subject: Re: [PATCH] backlight: pwm_bl: move suspend/resume entries from
 platform_driver to driver.pm
To: gaowanlong@cn.fujitsu.com
Cc: Barry Song <Barry.Song@csr.com>, Eric Miao <eric.y.miao@gmail.com>,
        Xiangzhen Ye <Xiangzhen.Ye@csr.com>, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Richard Purdie <rpurdie@rpsys.net>,
        Barry Song <Baohua.Song@csr.com>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Why not use SIMPLE_DEV_PM_OPS instead?
>

Mark's revision merged did use SIMPLE_DEV_PM_OPS

-barry
