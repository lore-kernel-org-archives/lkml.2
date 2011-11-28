Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab1K1KCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 05:02:33 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33772 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab1K1KCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 05:02:32 -0500
Message-ID: <4ED35BFE.6080900@mvista.com>
Date: Mon, 28 Nov 2011 14:01:34 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Cong Wang <amwang@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Subject: Re: [PATCH 10/62] ata: remove the second argument of k[un]map_atomic()
References: <1322371662-26166-1-git-send-email-amwang@redhat.com> <1322371662-26166-11-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-11-git-send-email-amwang@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 27-11-2011 9:26, Cong Wang wrote:

> Signed-off-by: Cong Wang<amwang@redhat.com>
> ---
>   drivers/ata/libata-sff.c |    8 ++++----
>   1 files changed, 4 insertions(+), 4 deletions(-)

    IMO, you should do this in a single patch, not piecemeal to keep the 
kernel bisectable.

WBR, Sergei
