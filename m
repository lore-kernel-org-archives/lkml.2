Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab2KMS3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 13:29:32 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:46124 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189Ab2KMS3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 13:29:30 -0500
MIME-Version: 1.0
In-Reply-To: <A3A921390EAE4044940E99EBF13D97321AE21FBB@FMSMSX104.amr.corp.intel.com>
References: <201211081915083774239@gmail.com>
	<509B962C.6070002@gmail.com>
	<C5551D9AAB213A418B7FD5E4A6F30A072D565E76@ORSMSX106.amr.corp.intel.com>
	<CANmqhJDJXcbUxyt6YD6ktxZCDJ=VqiwhGXP+fLMukQr0o-XwxQ@mail.gmail.com>
	<CAErSpo4xn9t=4yXGLdPQMtUJF=n38tYrMutAoj7NCsLUzQEbcg@mail.gmail.com>
	<CANmqhJAjwP8CLEKpgsDbT-7+n=hf30LbYrTAu+qDH09LzETD4g@mail.gmail.com>
	<A3A921390EAE4044940E99EBF13D97321AE21E15@FMSMSX104.amr.corp.intel.com>
	<CAE9FiQXnP2gpy9z6VNGSpimLkhDYKp6Qr=9nGZ9d-pKdohA4bw@mail.gmail.com>
	<A3A921390EAE4044940E99EBF13D97321AE21FBB@FMSMSX104.amr.corp.intel.com>
Date: Tue, 13 Nov 2012 10:29:28 -0800
X-Google-Sender-Auth: 9COtgzz5NTtP-Fz67EUaoXCqpf0
Message-ID: <CAE9FiQXTCjpSbAi_DAhQomDo3F1MBECUK48eMnUsyso3a_sayQ@mail.gmail.com>
Subject: Re: SR-IOV problem with Intel 82599EB (not enough MMIO resources for SR-IOV)
From: Yinghai Lu <yinghai@kernel.org>
To: "Li, Sibai" <sibai.li@intel.com>
Cc: Jason Gao <pkill.2012@gmail.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "ddutile@redhat.com" <ddutile@redhat.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 10:25 AM, Li, Sibai <sibai.li@intel.com> wrote:
>
> Never append "pci=realloc" for both kernel 2.6.32.279 and kernel 3.5.0 above.

well,  can you both post boot log with "debug ignore_loglevel" ?
