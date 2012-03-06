Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964930Ab2CFSYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 13:24:17 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64119 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148Ab2CFSYP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 13:24:15 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of computersforpeace@gmail.com designates 10.236.145.193 as permitted sender) smtp.mail=computersforpeace@gmail.com; dkim=pass header.i=computersforpeace@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120223000240.GA1931@gamma.logic.tuwien.ac.at>
References: <1329849524-23758-1-git-send-email-computersforpeace@gmail.com>
	<20120223000240.GA1931@gamma.logic.tuwien.ac.at>
Date: Tue, 6 Mar 2012 10:24:14 -0800
Message-ID: <CAN8TOE-OgUC+W12D1KkS2rpziYP1bgaF7CfP6fnYHJWsFZ=Hfg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] ahci: fix boot/resume COMRESET failures
From: Brian Norris <computersforpeace@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Norbert Preining <preining@logic.at>, linux-ide@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Lin Ming <ming.m.lin@intel.com>,
        "Srivatsa S . Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        "Rafael J . Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

On Wed, Feb 22, 2012 at 4:02 PM, Norbert Preining <preining@logic.at> wrote:
> On Di, 21 Feb 2012, Brian Norris wrote:
>> This series addresses regression problems with
>>
>>     commit 7faa33da9b7add01db9f1ad92c6a5d9145e940a7
>>     ahci: start engine only during soft/hard resets
>>
>> Because the fix provided by the above commit caused COMRESET failures and
>> 10 second boot-time/resume-time hangs for certain DVD drives, we need to
>> make the fix conditional to certain devices/platforms. Add a flag for this.
>
> I confirm that these patches without the previous fix also
> fixes the regression I have seen. Thanks.

Shouldn't this patch series be sent mainline during the 3.3 cycle?

Brian
