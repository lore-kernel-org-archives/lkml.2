Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab3AHXKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:10:07 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:59975 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729Ab3AHXKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:10:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V3 2/3] dmaengine: dw_dmac: Enhance device tree support
Date: Tue, 8 Jan 2013 23:09:48 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Viresh Kumar <viresh.kumar@linaro.org>, Vinod Koul <vinod.koul@intel.com>,
        andriy.shevchenko@linux.intel.com, devicetree-discuss@lists.ozlabs.org,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org
References: <3100e691db3f94c22afd98b609a1568d7e70dfe7.1350360935.git.viresh.kumar@linaro.org> <201212102208.52347.arnd@arndb.de> <CAKohpo=FjZuMOC-wuNc3q_FXbk546ttCLr55GkW9AL0Tz-HoBA@mail.gmail.com>
In-Reply-To: <CAKohpo=FjZuMOC-wuNc3q_FXbk546ttCLr55GkW9AL0Tz-HoBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301082309.48676.arnd@arndb.de>
X-Provags-ID: V02:K0:8etkf0zG+jYabnHqtq7Ko/8agS6ORwG5mopMnY8fJR7
 DA+gnXRwDrPnYrfDGyuueDT4Wg+JsKaY7Xwc0MXfR9QNBcGuRu
 R7pO3lzg0KCm2ZIKfahIBu7+Pttg+k64jw3kXoQ8XOgyuMo/cK
 JN4RK01R/Z16XN09hNA6MF3mEQ1yrMUx1UWxiXTNap3V1UoDFe
 AbdN8+WpCHmzV9VRBnvjrrJslFnDU4v+cJMr0ivAGRvz1i/1hr
 7qmbm+TilpycFURCT/bRFQ+k/wv0+ZFjeO00LgkuxrDTeJQMrY
 L8TtETac0UwbBITj+acHmnPIi2VNgBsEWWtL9Jd1xRVItXLQBe
 UQ4Pt3RxEd4CTW0wRWhQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 December 2012, Viresh Kumar wrote:
> I saw the binding document and it looks it can be applied to dw_dmac
> too, as there is nothing special for it.
> 
> The question is how? We are already late for merge window and this
> one is queued. Supplying a new patch, getting it reviewed/tested and
> being pulled by Linus is not so easy :)
> 
> Two ways:
> - Keep it as is, and i will fix it separately and quickly
> - Drop it :(

It seems we got both lucky and unlucky here, as all the dmaengine patches,
including this set and the generic DT bindings missed out in the end.
So there is time to fix it all for 3.9.

	Arnd
