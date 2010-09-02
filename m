Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab0IBUNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 16:13:25 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33260 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab0IBUNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 16:13:23 -0400
Message-ID: <4C800559.10701@oracle.com>
Date: Thu, 02 Sep 2010 13:13:13 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Fix typos
References: <AANLkTi=Y7RmojC2+1Zdw0jeGm99Gj7anVqReJkrgDmRg@mail.gmail.com> <20100902121853.e90f6c53.randy.dunlap@oracle.com> <AANLkTinehv75C+xhsDA_7HHoT9m_BkmL1aE_oyM9BJO4@mail.gmail.com> <4C800266.1000005@oracle.com> <AANLkTineHC5C=Sv5uZezx7-RF3_rQOJFBePhfzD6jfMF@mail.gmail.com>
In-Reply-To: <AANLkTineHC5C=Sv5uZezx7-RF3_rQOJFBePhfzD6jfMF@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/10 13:08, Lucas De Marchi wrote:
> On Thu, Sep 2, 2010 at 17:00, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> It looks good for Documentation/.
>>
>> And fixing typos is certainly something that we want to do in
>> user-visible messages, like printk strings.
> 
> What about comments and code?


That will require a lot more detailed review IMO.
Usually it is good to have, but not nearly as important as user-visible strings.

And you should copy trivial@kernel.org on the patch.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
