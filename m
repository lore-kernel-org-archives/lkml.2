Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab0I1Pf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 11:35:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53464 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063Ab0I1Pf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 11:35:26 -0400
Message-ID: <4CA20B21.7060809@zytor.com>
Date: Tue, 28 Sep 2010 08:34:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH] x86, nmi: workaround sti; hlt race vs nmi; intr
References: <1284913699-14986-1-git-send-email-avi@redhat.com> <4CA057EA.7000609@redhat.com> <768A5DC0-131A-4BC8-ADDD-044D8169545E@suse.de> <61284934-1AD3-4F7A-9488-D46FCEE9B753@suse.de> <4CA06147.7080805@redhat.com> <C725B379-9631-46E4-A825-E43A5120681E@suse.de> <4CA06373.5030501@redhat.com> <4CA112D1.2020004@zytor.com> <4CA1AC50.7000801@redhat.com>
In-Reply-To: <4CA1AC50.7000801@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2010 01:50 AM, Avi Kivity wrote:
> 
> Personally I think the safer route is to take the patch.  There are
> other processors besides Intel and AMD and we can't test all of them,
> not to mention various emulators and virtual machine monitors out there.
> 

Speaking for the smoltering crater that used to be *Transmeta*, I'm
(from memory) quite certain they blocked NMI and that this was
intentional behavior.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

