Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693Ab0DGOy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 10:54:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:37568 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932658Ab0DGOy1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 10:54:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,378,1267430400"; 
   d="scan'208";a="610968190"
From: "Luck, Tony" <tony.luck@intel.com>
To: "ananth@in.ibm.com" <ananth@in.ibm.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Wed, 7 Apr 2010 07:54:26 -0700
Subject: RE: [PATCH -tip] kprobes: Move enable/disable_kprobe() out from
	debugfs code
Thread-Topic: [PATCH -tip] kprobes: Move enable/disable_kprobe() out from
	debugfs code
Thread-Index: AcrV87PXBrR9iiJxS7mAbAdNU4ONIAAblHuQ
Message-ID: <987664A83D2D224EAE907B061CE93D53B8D735BC@orsmsx505.amr.corp.intel.com>
References: <4BB5FED3.4020809@redhat.com>
 <20100406222452.13879.48199.stgit@localhost6.localdomain6>
 <20100407014258.GA15311@in.ibm.com>
In-Reply-To: <20100407014258.GA15311@in.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Tue, Apr 06, 2010 at 06:24:52PM -0400, Masami Hiramatsu wrote:
>> Move enable/disable_kprobe() API out from debugfs related code,
>> because these interfaces are not related to debugfs interface.
>> 
>> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
>> Reported-by: Tony Luck <tony.luck@intel.com
>
>Acked-by:  Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Fixes my build warnings.

Acked-by: Tony Luck <tony.luck@intel.com>
