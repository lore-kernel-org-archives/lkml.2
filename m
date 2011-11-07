Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab1KGUQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 15:16:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab1KGUQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 15:16:56 -0500
Message-ID: <4EB83CB0.1090304@redhat.com>
Date: Mon, 07 Nov 2011 22:16:48 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: =?UTF-8?B?SsO2cmcgU29tbWVy?= <joerg@alea.gnuu.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm list <kvm@vger.kernel.org>,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Current kernel fails to compile with KVM on PowerPC
References: <20111107194838.GA23558@alea.gnuu.de>
In-Reply-To: <20111107194838.GA23558@alea.gnuu.de>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2011 09:48 PM, Jörg Sommer wrote:
> Hello everybody,
>
> I'm trying to build the kernel with the git commit-id
> 31555213f03bca37d2c02e10946296052f4ecfcd, but it fails
>

Alex, can we set up some buildbots for the ppc family, feeding on
kvm.git master/next?

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

