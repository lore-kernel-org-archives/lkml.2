Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab2FLNMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 09:12:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63706 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab2FLNMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 09:12:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Subject: Re: [PATCH 1/4] drivers/net/ethernet/sfc: Add efx_ prefix to set_bit_le()
Date: Tue, 12 Jun 2012 13:12:32 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        bhutchings@solarflare.com, grundler@parisc-linux.org, avi@redhat.com,
        mtosatti@redhat.com, linux-net-drivers@solarflare.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, kvm@vger.kernel.org
References: <20120611212735.f92ea521.yoshikawa.takuya@oss.ntt.co.jp> <201206111409.16093.arnd@arndb.de> <20120612220654.fd0246e6e687f7c79e5c988c@gmail.com>
In-Reply-To: <20120612220654.fd0246e6e687f7c79e5c988c@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206121312.32301.arnd@arndb.de>
X-Provags-ID: V02:K0:mtBo67CeRMHIy0phqoqCu3uWBiuRKe60VTfziPIOr0D
 +hFIhTzJsiz6dq0uSbNf4d8iWgJlY/i6jukUutNfmi0ca7p5nh
 3c26aqd6qJxRmHY/s5s3bqCw9WrzLskIoBzu52ptaBBAjBGyFc
 3cRUZPXUQgl9ILauyODvYmHoUjYwSyE2+ptBWQGImB8yCk20RL
 lhql2NSnoP6LJxij4AFeVltwMzEA+iKg/dKXrvDgx4amVlIau0
 hP0ucruSVwD10oWpkdmtROrYuLlFT0nx5ZSV2H9aRSVa+nIsS9
 XmCbW1dsQNCm3rmPZ+pNw+oVJsWysxXjije8ikETETC/r2GQiI
 IPOCH/cpPF9L7NWR9Jv4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 June 2012, Takuya Yoshikawa wrote:
> > 
> > Hmm, any reason why we're not just using the existing non-atomic
> > __set_bit_le() here? I think the helpers in sfc and tulip can
> > just get removed if you use those.
> 
> __set_bit_le() assumes long word alignment and does endian conversion
> when needed.

Ah, I see.
 
> To be honest, I am a bit scared of changing drivers which I cannot test
> on real hardware.

Ok, let's take your patches as they are then.

With the change to add clear_bit_le:

Acked-by: Arnd Bergmann <arnd@arndb.de>
