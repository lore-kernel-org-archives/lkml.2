Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758816Ab2HQS2G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 14:28:06 -0400
Received: from mail.windriver.com ([147.11.1.11]:43886 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758804Ab2HQS15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 14:27:57 -0400
Message-ID: <502E8D11.1010008@windriver.com>
Date: Fri, 17 Aug 2012 14:27:29 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
CC: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Peter Huewe <huewe.external.infineon@googlemail.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>,
        Tim Gardner <tim.gardner@canonical.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Debora Velarde <debora@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>,
        <tpmdd-devel@lists.sourceforge.net>
Subject: Re: [v2.6.34-stable 050/165] TPM: Zero buffer after copying to userspace
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com> <1345060109-9187-51-git-send-email-paul.gortmaker@windriver.com> <20120817154857.GD4039@herton-Z68MA-D2H-B3>
In-Reply-To: <20120817154857.GD4039@herton-Z68MA-D2H-B3>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-08-17 11:48 AM, Herton Ronaldo Krzesinski wrote:
> On Wed, Aug 15, 2012 at 03:46:34PM -0400, Paul Gortmaker wrote:
>> From: Peter Huewe <huewe.external.infineon@googlemail.com>
>>
>>                    -------------------
>>     This is a commit scheduled for the next v2.6.34 longterm release.
>>     http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
>>     If you see a problem with using this for longterm, please comment.
>>                    -------------------
>>
>> commit 3321c07ae5068568cd61ac9f4ba749006a7185c9 upstream.
>>
>> Since the buffer might contain security related data it might be a good idea to
>> zero the buffer after we have copied it to userspace.
>>
>> This got assigned CVE-2011-1162.
>>
>> Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
>> Signed-off-by: James Morris <jmorris@namei.org>
>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> [...]
> 
> commit 3ab1aff89477dafb1aaeafe8c8669114a02b7226 ("TPM: Zero buffer whole
> after copying to userspace") is something to consider to be applied
> after this, either with this update or later 2.6.34 update. It
> complements this change, just fyi.

Agreed.  I see no reason to not queue this.

Thanks,
Paul.
--

> 
