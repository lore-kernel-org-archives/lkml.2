Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250Ab0I0Vzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 17:55:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32959 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab0I0Vzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 17:55:54 -0400
Message-ID: <4CA112D1.2020004@zytor.com>
Date: Mon, 27 Sep 2010 14:55:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86, nmi: workaround sti; hlt race vs nmi; intr
References: <1284913699-14986-1-git-send-email-avi@redhat.com> <4CA057EA.7000609@redhat.com> <768A5DC0-131A-4BC8-ADDD-044D8169545E@suse.de> <61284934-1AD3-4F7A-9488-D46FCEE9B753@suse.de> <4CA06147.7080805@redhat.com> <C725B379-9631-46E4-A825-E43A5120681E@suse.de> <4CA06373.5030501@redhat.com>
In-Reply-To: <4CA06373.5030501@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2010 02:27 AM, Avi Kivity wrote:
> 
> I don't have write permissions for the spec.  If you can verify that all 
> existing and future hardware will mask NMI after STI and convince the 
> spec owners to update the specifications, I'm all for it; it's certainly 
> a cleaner solution.
> 

I'm trying to see if this is doable.  As you can well imagine, though,
it takes time.

	-hpa

