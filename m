Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab1EIUAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 16:00:05 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43453 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256Ab1EIUAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 16:00:02 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Miller <davem@davemloft.net>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, hadi@cyberus.ca,
        daniel.lezcano@free.fr, containers@lists.osdl.org,
        renatowestphal@gmail.com
Subject: Re: [PATCH 0/7] Network namespace manipulation with file descriptors
References: <m1tyd7p7tq.fsf@fess.ebiederm.org>
	<20110509.120408.48494155.davem@davemloft.net>
Date: Mon, 09 May 2011 12:59:55 -0700
In-Reply-To: <20110509.120408.48494155.davem@davemloft.net> (David Miller's
	message of "Mon, 09 May 2011 12:04:08 -0700 (PDT)")
Message-ID: <m1oc3btzk4.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19k8oirLk2L/A8pNDNcVCySgLMYjRF76Gk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> The networking bits look OK to me:
>
> Acked-by: David S. Miller <davem@davemloft.net>

Are you merging sendmmsg through the netdev tree?

The conflicts on syscall syscall numbers are an unfortunate pain.

Eric

