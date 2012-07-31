Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab2GaIj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 04:39:27 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60715 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755809Ab2GaIjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 04:39:24 -0400
Message-ID: <1343723956.3516.3.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH v4 0/7] ZPODD patches
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Aaron Lu <aaron.lu@amd.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Oliver Neukum <oneukum@suse.de>, Jeff Wu <jeff.wu@amd.com>,
        Lin Ming <minggr@gmail.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>,
        Shane Huang <shane.huang@amd.com>
Date: Tue, 31 Jul 2012 09:39:16 +0100
In-Reply-To: <5017458F.7000504@amd.com>
References: <1343379650-2867-1-git-send-email-aaron.lu@amd.com>
	 <5017458F.7000504@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-31 at 10:40 +0800, Aaron Lu wrote:
> Hi James,
> 
> Any chance of these patches get merged into 3.6?

Not 3.6 given that the series was only finalised a week into the merge
window.  Generally because of the merge frenzy, linux-next doesn't work
very well during this period so there's no way of getting any serious
build test coverage.

James



