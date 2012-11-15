Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993046Ab2KOKR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 05:17:59 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:33871 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423276Ab2KOKR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 05:17:57 -0500
MIME-Version: 1.0
In-Reply-To: <CAJLyvQxJeNgGc8sQiV_qmKCfvfWQKyR8S5ZMNCtETvJLMQH-oQ@mail.gmail.com>
References: <1352460548-3494-1-git-send-email-hongbo.zhang@linaro.com>
	<1352460548-3494-2-git-send-email-hongbo.zhang@linaro.com>
	<1352967218.2080.15.camel@rzhang1-mobl4>
	<CAJLyvQyu_oU7xx92JTOj6bvF+7-hOJfM=kTHj6JMogaYjC+Jww@mail.gmail.com>
	<1352970823.2080.22.camel@rzhang1-mobl4>
	<CAJLyvQxJeNgGc8sQiV_qmKCfvfWQKyR8S5ZMNCtETvJLMQH-oQ@mail.gmail.com>
Date: Thu, 15 Nov 2012 15:47:57 +0530
Message-ID: <CAKohponUGQNMvA0T1qhZbTGnK12upy4gcTPq4ZfZ-enLDbf4+w@mail.gmail.com>
Subject: Re: [PATCH V5 1/2] Thermal: Add ST-Ericsson DB8500 thermal driver.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Hongbo Zhang <hongbo.zhang@linaro.org>
Cc: Zhang Rui <rui.zhang@intel.com>, linaro-kernel@lists.linaro.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, amit.kachhap@linaro.org,
        STEricsson_nomadik_linux@list.st.com, kernel@igloocommunity.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 November 2012 14:53, Hongbo Zhang <hongbo.zhang@linaro.org> wrote:
> this is a driver for ST-Ericsson u8500 board(Snowball), with a ARM core inside.
> so you should compile like this:
> make  ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- u8500_defconfig
> make  ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- uImage

Then we must have a DEPENDS_ON in Kconfig entry for these.


--
viresh
