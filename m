Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab1GGRiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 13:38:55 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48963 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab1GGRiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 13:38:54 -0400
Message-ID: <4E15EDC1.7020304@gmail.com>
Date: Thu, 07 Jul 2011 19:32:49 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Sergiu Iordache <sergiu@chromium.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] char drivers: rammops improvements
References: <1309994990-4729-1-git-send-email-sergiu@chromium.org>
In-Reply-To: <1309994990-4729-1-git-send-email-sergiu@chromium.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/07/2011 01:29, Sergiu Iordache ha scritto:
> Improves the ramoops module by adding a dump_oops to the platform
> data, adding a record_size parameter and adding a debugfs for memory
> area access.
>
> The patch was built on the 2.6.38 kernel and is based on the following
> patches which were applied from the mmotm tree:
> ramoops-add-new-line-to-each-print
> ramoops-use-module-parameters-instead-of-platform-data-if-not-available
> ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes
>
> This series is different from the initial two by being built on the ramoops modifications present in the mmotm tree and by using a different
> approach regarding the debugfs entry.
>
> The changes were tested on a CR-48 machine using the 2.6.38 kernel.
>
> Sergiu Iordache (3):
>    char drivers: ramoops dump_oops platform data
>    char drivers: ramoops record_size module parameter
>    char drivers: ramoops debugfs entry
>
>   drivers/char/ramoops.c  |  151 +++++++++++++++++++++++++++++++++++++++++++----
>   include/linux/ramoops.h |    2 +
>   2 files changed, 142 insertions(+), 11 deletions(-)
>

The patch series is ok for me.

Marco
