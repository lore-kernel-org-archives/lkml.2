Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab2F0Gyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 02:54:38 -0400
Received: from lvk-gate.cmc.msu.ru ([188.44.42.233]:37606 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753634Ab2F0Gyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 02:54:36 -0400
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jun 2012 02:54:36 EDT
X-Spam-ASN: 
From: "Nikita V. Youshchenko" <nyoushchenko@mvista.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: UBI fastmap updates
Date: Wed, 27 Jun 2012 10:48:26 +0400
User-Agent: KMail/1.9.9
Cc: Richard Weinberger <richard@nod.at>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com
References: <1340456602-46050-1-git-send-email-richard@nod.at> <CAKYAXd-3ArdssdotKHjvUU0f+yqcFC6y2rHF-mqnJnUcP=+eOg@mail.gmail.com>
In-Reply-To: <CAKYAXd-3ArdssdotKHjvUU0f+yqcFC6y2rHF-mqnJnUcP=+eOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201206271048.31524@zigzag.lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi. Richard.
>
> Would you infom me how much UBI attach time is improved with fastmap ?

I'm not Richard but still.

On board I'm currently working on, ubi attach time for 1G chip without 
fastmap is more than 5 seconds. With fastmap, it is less than 250 
milliseconds.

Nikita
