Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097Ab1FJVUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 17:20:06 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59855 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab1FJVUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 17:20:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=L1BeMdKIWDdafJDORfALvUaOcvc/BLYmOsZ1yLXvMfe94moRsePf7Ep0phG3yxMFv0
         ArBx0A5buASbVD4M7bbnoLLqwDRiqxjmuyztWivm9lpfjvOtoEDxEgeBfuH2M8M0S2ra
         ooQq0/KUD3mp6QMDYYY2v3oTKTCbboTlofdpc=
Message-ID: <4DF28A81.8070309@pobox.com>
Date: Fri, 10 Jun 2011 17:20:01 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mark Lord <kernel@teksavvy.com>
CC: Tejun Heo <htejun@gmail.com>, Bruce Stenning <b.stenning@indigovision.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: sata_mv port lockup on hotplug (kernel 2.6.38.2)
References: <20110425162242.GB30828@mtj.dyndns.org> <C1438B59050E1B4C9482FF3266AD6BA32C77554BDC@gretna.indigovision.com> <20110426135027.GI878@htj.dyndns.org> <C1438B59050E1B4C9482FF3266AD6BA32C77554C70@gretna.indigovision.com> <20110426155229.GM878@htj.dyndns.org> <C1438B59050E1B4C9482FF3266AD6BA32C77554C91@gretna.indigovision.com> <20110430140109.GJ29280@htj.dyndns.org> <C1438B59050E1B4C9482FF3266AD6BA32C777089B2@gretna.indigovision.com> <20110525094127.GF10146@htj.dyndns.org> <4DF20E03.9030502@teksavvy.com> <20110610140155.GJ15235@htj.dyndns.org> <4DF25526.9010800@teksavvy.com> <4DF256E1.4010703@pobox.com> <4DF28360.1090206@teksavvy.com>
In-Reply-To: <4DF28360.1090206@teksavvy.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2011 04:49 PM, Mark Lord wrote:
> Well, it's not getting any testing sitting outside of the kernel right now.

It gets whatever testing linux-next gets...

	Jeff



