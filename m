Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab0KRISz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 03:18:55 -0500
Received: from smtp.nokia.com ([147.243.1.48]:57742 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519Ab0KRISw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 03:18:52 -0500
Subject: Re: [PATCH 1/2] kmsg_dump: adding to reboot, halt, poweroff and
 emergency_restart path
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        ext KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "simon.kagstrom@netinsight.net" <simon.kagstrom@netinsight.net>,
        "David.Woodhouse@intel.com" <David.Woodhouse@intel.com>,
        "anders.grafstrom@netinsight.net" <anders.grafstrom@netinsight.net>,
        "jason.wessel@windriver.com" <jason.wessel@windriver.com>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "eparis@redhat.com" <eparis@redhat.com>, "hch@lst.de" <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "marco.stornelli@gmail.com" <marco.stornelli@gmail.com>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        Aaron Durbin <adurbin@google.com>,
        "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C12D6E2FA@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C12D6E2F5@USINDEVS01.corp.hds.com>
	 <5C4C569E8A4B9B42A84A977CF070A35B2C12D6E2FA@USINDEVS01.corp.hds.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Thu, 18 Nov 2010 10:16:51 +0200
Message-ID: <1290068211.2270.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 10:00 -0500, Seiji Aguchi wrote:
> This patch alters mtdoops and ramoops to perform their actions only for KMSG_DUMP_PANIC,
> KMSG_DUMP_OOPS and KMSG_DUMP_KEXEC because they would like to log crashes only.
> 
>  Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>

Looks OK,

Reviewed-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

