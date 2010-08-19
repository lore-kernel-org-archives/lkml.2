Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641Ab0HSG6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 02:58:30 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60736 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab0HSG62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 02:58:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=LsWEl1LFSmkVV64/n08/OYBY5Q4XtygmUmRhBGoUTrZdbnGbXyf6Wh92/JENHDicVr
         Q+uKtgaVcAEhKK+wN0ceqUX96tc3lmUu1GVNZ9nsjKjp/gH0a9VevFi9ofGvD9eEul4u
         m0HUAlypSdr1G/3ocS1lmMdBu7O5Hj9uYUm+4=
Message-ID: <4C6CD610.3090902@garzik.org>
Date: Thu, 19 Aug 2010 02:58:24 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Tao Ma <tao.ma@oracle.com>
CC: linux-kernel@vger.kernel.org, Jiri Kosina <trivial@kernel.org>,
        Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: [PATCH] trivial: Use kzalloc in idedisk_prep_fn.
References: <1282190541-12154-1-git-send-email-tao.ma@oracle.com>
In-Reply-To: <1282190541-12154-1-git-send-email-tao.ma@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2010 12:02 AM, Tao Ma wrote:
> Cc: Jiri Kosina<trivial@kernel.org>
> Signed-off-by: Tao Ma<tao.ma@oracle.com>

Acked-by: Jeff Garzik <jgarzik@redhat.com>

