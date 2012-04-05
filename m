Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab2DEUWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 16:22:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755584Ab2DEUWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 16:22:31 -0400
Message-ID: <4F7DFF01.4060309@redhat.com>
Date: Thu, 05 Apr 2012 17:22:25 -0300
From: Marcelo Leitner <mleitner@redhat.com>
Reply-To: mleitner@redhat.com
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Veaceslav Falico <vfalico@redhat.com>
CC: netdev@vger.kernel.org, Jay Vosburgh <fubar@us.ibm.com>,
        Andy Gospodarek <andy@greyhouse.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] bonding: properly unset current_arp_slave on slave
 link up
References: <20120405134743.GB16870@darkmag.usersys.redhat.com>
In-Reply-To: <20120405134743.GB16870@darkmag.usersys.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2012 10:47 AM, Veaceslav Falico wrote:
> When a slave comes up, we're unsetting the current_arp_slave without
> removing active flags from it, which can lead to situations where we have
> more than one slave with active flags in active-backup mode.
>
> To avoid this situation we must remove the active flags from a slave before
> removing it as a current_arp_slave.
>
> Signed-off-by: Veaceslav Falico<vfalico@redhat.com>

Signed-off-by: Marcelo Ricardo Leitner <mleitner@redhat.com>

