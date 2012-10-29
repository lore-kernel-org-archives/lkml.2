Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab2J2Kun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 06:50:43 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:55938 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750846Ab2J2Kul convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 06:50:41 -0400
X-Greylist: delayed 577 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Oct 2012 06:50:41 EDT
Message-ID: <1351507249.11783.4.camel@thor.local>
Subject: Re: 3.7-rc2: corrupted image on Radeon HD 7800 after restarting X
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Frederik Himpe <fhimpe@telenet.be>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Date: Mon, 29 Oct 2012 11:40:49 +0100
In-Reply-To: <k6engr$knj$1@ger.gmane.org>
References: <k6engr$knj$1@ger.gmane.org>
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAIAAADYYG7QAAAAA3NCSVQICAjb4U/gAAARr0lEQVRYwz2Yy5Nl2XXWv2+tvc8595HPysyqrKzst1pWq61uNVIrCIwkOxARTBh44hkDCI+J4A8gAgaYIQNHMGBChMEQNoRRSCEJkMCAZJtwd0vdUquf1a/qrHdm5ePmvfecvddaDG435w84e++19/p937f43e//qVXTlCJcqCRIISEkKEKCICHCCBAQRtJsHipEeESklEC6BxEqDEBECDKp1yIiFCICFJIAwsOJ1Y8BUunmAEQEiBROTcnMVAQIkexeRTQCJEAIJbxSNMJFk4qYu4IRQRCIxXx569bRvTu3+77v2tHm9sbjTzy5tb3lxUQVACIICTAiQAZDRSNCVc0cQQpUk7sDkiLAIEAEKLJaxqtLEiHDDFlENByAIMIjRATu4ehLef2v//qt1155cPt2KSXcg0wprV3Z++KLX/3mt745XR+rkEBEQCCQCFfVAEhGWKNaV6dGACCRIjxCVdQ8FOJuQhGhQMxqThpWHVAVDQpopWhKpdRXX3ntztuvt8uZPno4tYUIUmJWCfr89P4b/+NH9z547+vf+vaLL73o7qqCABgURiAYSZOZO6hARYBUQUCSJjVzBnNKpZambRgBSLWakkYAAVEyIhwWpqJ37h7/+PvfvSKLHfWh9jutXknrAe+a3Ko2bUaTTdS0fvrzvyLk+ReeC00ElAzACVWN8KRi1SGiFIQQQWVyC36+YpMbr676WZ2IIIlAOBxQRATefPPdn/3gv3zx2jqHoVwuWWojkhMJ5qxJJHd51LbNeKpdl0frR+++/rrbi19/KYkEAEBBJSMkHCknMxfRiKBIOCU8CIkgAh4AYGZE5JytmptbAO7KCMEvfvn2j/7kj5/dncT8spzP6mLJ6slBGBESQVIjxEF3lAFl+fTulfLJO2/98m2CJJMqSQQjKCpwCEUoo
 ikAAuLh4
	GrrdHclBVCq15KSursAKmIW9++d/OA//vvfvL5RLi6Gy2W4EXCzMLMhwsOrwcyXxWqJYakW0fe+vHx6b+fu63/5ySdH5Kq3CUBECVKVELNIQgZBipKMCAYJJQEmTbUWirqFEIS7G+nf/+73nths7HJRFwsvg/WDDwPcwkEHvJq7WaUQGjCzsozSx7LHcvnSE9d//Gd/6g7zEIKUFY+AAJBTcieD4iYASCHoYVQBvNSiScOrqLg5qYDcvXdy843XtrpxLX0YbHAPRDDMA6saf8Y5OHzptZoPJmbqzqHXYl/embz3zgeEgEpQKCKJFIq6G8JUGaLiEWaDKgmJWlUTSBEARFA1RQDAT37y59ujxqxGwKtHWJiHu5uHmQgZkBClSFrRKpRMFHFTN3p97vEbv/jp/yIE4OqQCmEQAAhDBIKIlTiIeSACpLnlrG5OEuGr+1z0/V/9n79Yb3N4hIWHW7hX92IeAdKLIUhzgLUEHIhoNDe5bZuuG42TMixG/cVHH98S0UBEOJJ6MGkWSQlCCiASwaTKiIATZCAsQF1hnhQwjo7ulMXFpGvDwz281nD3gAPu7hGu4uERdDe36hGAStPlPGpG65InEikFnrm+88F770YEAiISFiklhpMCEU0KhIjIMFR+9qFaQUBAIcNDRIV69859wlVopTdzc5oj3MIiIAbYYF7cEdbXOnitVksdyrJGMKdaHNIkbW7s7Ty8c4eACFcPlwgQCiQKAzllAZBUAYRFRAiFRAQ+E91agJjPzhno+1LNLcLdaeZeyQgY3AGPCLi5wBG1FBEXAmCtbjYQnIyn466ty0sgIIkklebGJCBAkBJCCSsgIlyUAZAwM0qACPPP5Vbc47Lv3TwAh4UHIO4UJAkKRVXAlU4HIQhRyW03WclibhpRdUcSCYTwcy+BYISoAiRFg0IRwMMdEQogQElhsVLEsCC1llqrn80X7gx3QDxgTgv/7A15hFNSA1BCmia3Td
 ekcZM75l
	a0CQszm/dDMVdV//wqVBMp7pVKiwp6+gw2IoFwAg56hYiqlFIBZsrZ+TnAvq/VLTUJ5kY1t8UQWdElmWQKK9CmplG33DS5G7vms76enfdW+ul4dE3S5dD3ywGgKN1iBQsAquoeAqSUUrgrV26QAnpYSBYyHBEhKuFey0BGEgoIyqzU9+4+WJRaLADuTkZXp5Or03Zbl2Md56ZBTqfL/pNHt9+798YnD85Tlq3p2gtfevZLT+8xwtwVmRLhkZQOhAcFAq1mCcHq1rat1RoeEHUzZQ7Eym86MJ5MVGScsxDnQ//GrXt3z2cBQsQCR7Pl5OHp4dr0qd3p3np/9crWjMPNW0e3T8/nZTiZ1wJOJ/OzwYaoF7NZNbQRiBV0TEQMIUyBCItkcBAUgdDdVsYWQKxQgWDE5sb6+vaVufDPb94+vrycZn75YPvGlY2T2fL+2YVZlGLHdfjw4+PM4+3xg82N9Xm/XHo9mc3X2+blZ2+89OxTFwPvPDp+VPiv/vDffu1rL/2db76UoB5IqjQIEBBKWgFBvFYVCUBIkh4OuJup6C+/973jn/xgf3fnuPDjk9Pf2Jt+4/G9JPLjdz79b+8cvXtafHuy0NJkO1xL95b+q4ezn916+NHZshNYXZwCcf2Z//3aG09eX//NL+wdbGFvuPlH/+4/9dUiPKVk1VbqAQYFCYCogmK1asrhhs+vSlS92vs//O/Gcnxy/uzOxtn2+hO7W8Py8taD8/22u9p1WdMUtdlqqOqXzIyXDrZTbk/r/Mq2X712TfNk4/zhY08++dHH73/7d3572rTrb90+/8KNUaNUDVCpIuJRCKpoCg9RdYKazEwIQuGRkpiFmV+eXuqVptbYGnd703G/XFzOl0/tbqyPmi6pIU7my7ocSdjdRb+d5OWt8YvPPPGjO8eHE0E/37mysf/E9c3t3flwsbicX9m5cjG/9czXv5BTcncyBSwIEQXC3ZJq9gDcqCKqClarmnQ
 YhqbtAux
	2ttkO4+gzZX99PF9c7K6NiCANFkyyPm7bZOH+xsPZ8+NJBkVSy/SlLz55fnEWtczPT7uct7c3s+RxO3lX8aUXvlzdm5TM4rO0BhC0cIE7vAKQAEkHSDWz3LRhlYKnf+vl2cVisCBkf2PycGFN6ibNaJqbLnHEGMHH8NmyiOHG5hTBftY/f3XvtXdvT9tJKlLOl77sNyabh/s3xuPJrRtPP/v0ISgGIqGEpaQBXUWOBAoYXCHKTCQ5fOWKPED4wYsvvfE/f7wcSg1L6s/vb77/YNaSI/FWJODnQz1ZlrNF/dbh7iRnRlSLv/H4U7P33vz5h3cnWXYmeXZZPvr03jtHjz48X/zeP/p9oThCNZVh2TatBSJqyrmUkkAQdPOUk3m411UWdHcQomn94KDpJnU4PytlN+dp0q/srYdF39vM+lK5nThSHm5064kiDmkLfL68fPHwYH52grWti+LNZHp49bGnH9u+J+PNzbUVjQlfWWx3y7kttaiIcGWWIgBxwAEy4v/rE9COu6sHh9NGz5YDQVIFFLdx4n7XPrWxNgJbTdcma12TyKQiScLKcnt7r5Xm4pP3D9aaZ/Z2rk/HdFvf3QNIFaZUAxRGOCIAqCg1iYd7hJDFKiIENHMRcXNgtbX4je9859pkOutLqBolgCTssm6vj82H877ubo4mbRqlnEVUIKLare0fHB4+9cTR/fvHn74vddGknDTpZM3DSEVACEpSSe4wc0oGIR5YJTJGWK0RIaruBqJWi4hwXPvKl3/3H/+TjZ2rlQpVUc0q6+OGKh89mD0a/I3bp3/x0a07F/OuTW1Wyblp9eT4zg/+8ufLduPjo7sXZw+qDaLK8bpQAANcROERCE0qSUXgZhLhAGutoARhVghEmAdAluqak0dcf+Lx3/uHv+/aBKkSOadu3PzqzvGHF8sH/XB/sTjqh//6wdFPPz5C14za0Ix//Wc//ODk0Uez+d3BH54+HOp8aFq2LUWE
 miQjoKpm
	QVV4WC2ApFpqahOCbpUIh8BdJAlNVNyj1rqa9+zuX51ubc8fzD1yTnzUL26ezE5qzRSQbep2xObGH751c/9o2v361ubaBhtdnpcy7m4/OOEo1c2dQEQEVIoNKgkimhrQSdQSTaMJgVKrMNw9gpoERPWSNK0E39wlZVBUYu/xx28+/LQiIvP4bLE26Syw0Y02M8aiDbjejiB6ePXqxni6u39N1ye/+PjdWT/rvVhOdf2KcCXZyKn1ACmlDDnnCKREAEkEeeXFmBAevnKRKog6WNeNaq0BVjchfLGIyIa6dAfT1amO0XxwfLHs8sHmtBmvp831zST7zz939/aHf/BH/+Hx0eTvfueFLsX+3oFPrmC06QZNSUi4g3CrOTcrPx0BakoiaivXEasRHt2sSQ1Jj9WoTc0s5RzA2b0jwl1kKIOQDuRGr+XxxcX8YZn1UxsWC+xsvfPWry7uPvoHX/vbh8/u1bGfnh/vHj7ZXH0yaQ54uLuoaobVlHK1KqJuTiEpaZXrDVQigFVorQ4hck5eCzUnTasBzfzRcfTzSKOLoRfEADpi50raaNe1xFbktWj1Qb+GzS9943fWN1t0/elQmLGzf5iuXCu1pKSrkaOFi4q559Sa1abtzCsiEgJMCaV3iGoiEeFJmmq1SeowYYRXkmcP7g7zOUpftDXmhg5KI6mYTzebjJSKdW3a3tjau763tqUycrKbrnU7kyvT608wJdXPRi8BIAiEiAZh4YkqBOAplKX2uW2t9MHwUlJuqq2io4Y5EsPjrV++8eCXrzCqBKMMKbdRy6RpLssySZqZVdQSca/O1xZ1/1Ku3rdre7s5Ndub2+PN6Xj/CU0iIrUOq+FQyrIiC4CcW4pEWEBSKUPXtFaLaiYZwlhZAaJ6EZH7947/4F/8yy2ffWV/UwlRipeItEq30KavtdOcFf18GMjCXAtGbbestXcejkft9o1mbS0A9xDJFFn5dQAg3YIiVqvmBHPJk
 kqpgDiMs
	uozCIVCN7tz5+4/+6f//CDNn9vtYBUMUSQVuK9SStemwWMZpRaDAw6vhogh/OGj86LadW2v09nJvPYwp8hnbeQRiBAiYCKEwEoBmQymmqqXVtPQD13bFasquV/Mf/2rN//w3/xxN5zfuLpBD2gAqspRzqmKucDqUCw1jVD6vuTUTJus1Go4OVtsbG+NJ5NHs+X//eSDb35jXKunpmm7jmJr69NSl5ryqmYAhRLCUkpCMMKbpqmlimaLcLM7d4+O799+5dVfnxyfdFKXddI2LUhJmjTlRkvWZVEgtb6o9EZFJTfQcZdJWVub7O7s3njssBm1P/rZax/Z9rf/1ldFeHz3aPfg8VqWZ49O967vW7hwpaQB95waUJNHSDCCEM4vzy/OTpeX56Uf6jDsX9vx8Lnh6Gy5td9KEk2ScspZG9Wm02FQyWlN1fqBhk7kdLHYXR/fONi/dm13PBm1k7Vf3/zwfEyDPnp4b7qxefbgzmR7ezmfPbxzb3P3mmYBLKlQaF4ATUqxCNZy/96n/fxCqYBqahPw2I3p/v7+7dt33z62Lx50o1VxsqQ2iaRGtRuhmY77yOJm80WnabK1llVLSuON7fHmdqAen57OykU4tnb3Z6fHy8V8srm5d/3J93/96sbO1azjwYYQhPcqKYgUguXs4vT4PuCqjVVvu0k/nzXNKDWj3/qbL//Jf/7+ydzffTD/6uFW02RVIZNoyo3kpGNElZGlbtquWR0mk+l0ur5/cLC/Nb44vXztzbdPjk/yNNrp5uz8ZLK+0Y7GD+8cfeGFg+n65vnJ/WZ/0rbtbHYxHidD0ENOHt49PXmAgLsgNOduNFrXps1NO55sfOPlrx8cHgD6i6PZRUXqOubERkJXoJdRbiYctrRfy5ePXclP7TTPHUy/sJWa/vLho7NXXn21GITadmPNebq+hbBuPF5cnG3uXP/05ju5zcNymIzG84W1TWvhUoc+tePx2nbOI0ekppusbb
 XdhCKk7+
	wd/O7f/3uaZFH9pzePFxYIQhqKQjW3XdONctMoNYGjbjwejbu2Wy6Wjy77W5/e+ejTT6Ht9tZOHRZ7+4ezs9Pda9dSbm5/8sHW9p7VYXb+KDdNbprS92STU/P/AEhtCwKT6WJ7AAAAAElFTkSuQmCC
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-1.0 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fre, 2012-10-26 at 19:15 +0000, Frederik Himpe wrote: 
> When I restart my display manager (GDM) from tty0, I get a corrupted 
> image where parts of the X display before I restarted GDM become visible 
> on both the newly started X server instance as on tty0. When moving the 
> mouse in X, the current (correct) image around the cursor is replaced by 
> the image which was shown before X was started.
> 
> 01:00.0 VGA compatible controller [0300]: Advanced Micro Devices [AMD] 
> nee ATI PITCAIRN PRO [Radeon HD 7800 Series] [1002:6819] (prog-if 00 [VGA 
> controller])
> 	Subsystem: PC Partner Limited Device [174b:e218]
> 	Flags: bus master, fast devsel, latency 0, IRQ 48
> 	Memory at e0000000 (64-bit, prefetchable) [size=256M]
> 	Memory at f7d00000 (64-bit, non-prefetchable) [size=256K]
> 	I/O ports at e000 [size=256]
> 	Expansion ROM at f7d40000 [disabled] [size=128K]
> 	Capabilities: [48] Vendor Specific Information: Len=08 <?>
> 	Capabilities: [50] Power Management version 3
> 	Capabilities: [58] Express Legacy Endpoint, MSI 00
> 	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
> 	Capabilities: [100] Vendor Specific Information: ID=0001 Rev=1 
> Len=010 <?>
> 	Capabilities: [150] Advanced Error Reporting
> 	Capabilities: [270] #19
> 	Capabilities: [2b0] Address Translation Service (ATS)
> 	Capabilities: [2c0] #13
> 	Capabilities: [2d0] #1b
> 	Kernel driver in use: radeon
> 
> dmesg, .config, lspci and a picture showing a tty0 with parts of the 
> image corrupted by the image of the GDM screen before it was restarted, 
> can be found at http://artipc10.vub.ac.be/~frederik/linux-3.7-rc2/

Please also provide the Xorg.0.log file from after you restarted gdm.


-- 
Earthling Michel Dänzer           |                   http://www.amd.com
Libre software enthusiast         |          Debian, X and DRI developer
