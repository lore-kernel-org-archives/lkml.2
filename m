Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab0G1K26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 06:28:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754874Ab0G1K2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 06:28:47 -0400
Message-ID: <4C50065A.6050500@redhat.com>
Date: Wed, 28 Jul 2010 13:28:42 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Nested SVM fix and next_rip emulation
References: <1280247261-19115-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1280247261-19115-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 07/27/2010 07:14 PM, Joerg Roedel wrote:
> Hi Avi, Marcelo,
>
> here are two small patches for kvm-amd. The first patch fixes a small bug in
> nested svm efer handling. The second patch implements emulation for the
> next_rip feature.

Please post test cases for both patches.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

