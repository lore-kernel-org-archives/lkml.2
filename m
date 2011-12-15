Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643Ab1LODLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 22:11:20 -0500
Received: from lo.gmane.org ([80.91.229.12]:46757 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755809Ab1LODLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 22:11:19 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Gene Smith <gds@chartertn.net>
Subject: Re: wifi iwlagn fails to authenticate after wake from suspend
Date: Wed, 14 Dec 2011 22:11:00 -0500
Message-ID: <jcbog6$n15$1@dough.gmane.org>
References: <j881g5$tdf$1@dough.gmane.org>  <alpine.DEB.2.00.1110252325090.20273@chino.kir.corp.google.com>  <j8fvka$fu0$1@dough.gmane.org>  <CA+tb8OUHNbhVN_KiEkqXJW1apFoExRM5Vrn=ES5SF3sFoGOMfA@mail.gmail.com> <1323701322.1806.24.camel@wwguy-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 24-158-184-117.dhcp.jcsn.tn.charter.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
In-Reply-To: <1323701322.1806.24.camel@wwguy-ubuntu>
Cc: linux-wireless@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2011 09:48 AM, wwguy wrote:
> On Sun, 2011-12-11 at 22:36 -0800, Matías Aguirre wrote:
> maybe you system has issue with BT, we seen this happen on some cases.
> try the following module parameter and see if help
>
> $sudo modprobe iwlagn bt_coex_active=0
>
> Thanks
> Wey

This fixes it for me too!

-gene


